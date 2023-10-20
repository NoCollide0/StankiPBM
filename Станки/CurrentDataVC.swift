
import UIKit

class CurrentDataVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var powerLabel: UILabel!
    
    @IBOutlet weak var manufactureLabel: UILabel!
    
    @IBOutlet weak var linkLabel: UILabel!
    
    var checkLinkValidation: Bool = false
    
    var validLink: URL?
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrentDataVC()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCurrentDataVC()
    }
    
    
    
    
    func setupCurrentDataVC() {
        //Картинка
        if mainDataArray[currentData].imageSelected == true {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
            imageView.image = UIImage(contentsOfFile: dataDirectory.appendingPathComponent("\(currentData!).jpg").path)
        } else {
            imageView.image = UIImage(named: "defaultStanok")
        }
        
        typeLabel.text = mainDataArray[currentData].type
        nameLabel.text = mainDataArray[currentData].name
        powerLabel.text = mainDataArray[currentData].power
        manufactureLabel.text = mainDataArray[currentData].manufacture
        
        if mainDataArray[currentData].link == "" { //Проверка наличия текста в link
            linkLabel.text = "Документация: нет"
            checkLinkValidation = false
        } else {
            if !mainDataArray[currentData].link!.hasPrefix(".") && !mainDataArray[currentData].link!.hasSuffix(".") && mainDataArray[currentData].link!.contains(".") { //Проверка валидности link
                if mainDataArray[currentData].link!.hasPrefix("http://") || mainDataArray[currentData].link!.hasPrefix("https://") { //Код для полностью правильной ссылки
                    checkLinkValidation = true
                    validLink = URL(string: mainDataArray[currentData].link!)
                    
                    //Настройка отображения linlLabel как ссылки
                    let attributedText = NSMutableAttributedString(string: mainDataArray[currentData].link!)
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: mainDataArray[currentData].link!.count))
                    attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: mainDataArray[currentData].link!.count))
                    linkLabel.attributedText = attributedText
                } else { //Код для не полностью правильной ссылки
                    checkLinkValidation = true
                    validLink = URL(string: "http://\(mainDataArray[currentData].link!)")
                    linkLabel.text = "\(mainDataArray[currentData].link!)"
                    
                    //Настройка отображения linlLabel как ссылки
                    let attributedText = NSMutableAttributedString(string: mainDataArray[currentData].link!)
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: mainDataArray[currentData].link!.count))
                    attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: mainDataArray[currentData].link!.count))
                    linkLabel.attributedText = attributedText
                }
            } else {
                checkLinkValidation = false
                linkLabel.text = mainDataArray[currentData].link //Если ссылка не валидна то просто пишем текст
            }
        }
        
    }
    
    
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toEditCurrentDataVC", sender: nil)
    }
    
    //Кнопка перехода по ссылке
    @IBAction func linkButtonTapped(_ sender: Any) {
        if checkLinkValidation == true {
            UIApplication.shared.open(validLink!, options: [:], completionHandler: nil)
        }
    }
}
