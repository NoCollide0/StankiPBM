
import UIKit
import RealmSwift

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
    
    var currentMachine: MainDataRealm?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        currentMachine = realm.objects(MainDataRealm.self).filter("id == %@", currentData).first
        
        setupCurrentDataVC()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCurrentDataVC()
    }
    
    
    
    
    func setupCurrentDataVC() {
        //Картинка
        if currentMachine?.imageSelected == true {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
            imageView.image = UIImage(contentsOfFile: dataDirectory.appendingPathComponent("\(currentData).jpg").path)
        } else {
            imageView.image = UIImage(named: "defaultStanok")
        }
        
        typeLabel.text = currentMachine?.type
        nameLabel.text = currentMachine?.name
        powerLabel.text = currentMachine?.power
        manufactureLabel.text = currentMachine?.manufacture
        
        if currentMachine?.link == "" { //Проверка наличия текста в link
            linkLabel.text = "Документация: нет"
            checkLinkValidation = false
        } else {
            if currentMachine!.link!.hasPrefix(".") && currentMachine!.link!.hasSuffix(".") && currentMachine!.link!.contains(".") { //Проверка валидности link
                if currentMachine!.link!.hasPrefix("http://") || currentMachine!.link!.hasPrefix("https://") { //Код для полностью правильной ссылки
                    checkLinkValidation = true
                    validLink = URL(string: currentMachine!.link!)
                    
                    //Настройка отображения linlLabel как ссылки
                    let attributedText = NSMutableAttributedString(string: currentMachine!.link!)
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: currentMachine!.link!.count))
                    attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: currentMachine!.link!.count))
                    linkLabel.attributedText = attributedText
                } else { //Код для не полностью правильной ссылки
                    checkLinkValidation = true
                    validLink = URL(string: "http://\(currentMachine!.link!)")
                    linkLabel.text = "\(currentMachine!.link!)"
                    
                    //Настройка отображения linlLabel как ссылки
                    let attributedText = NSMutableAttributedString(string: currentMachine!.link!)
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: currentMachine!.link!.count))
                    attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: currentMachine!.link!.count))
                    linkLabel.attributedText = attributedText
                }
            } else {
                checkLinkValidation = false
                linkLabel.text = currentMachine!.link //Если ссылка не валидна то просто пишем текст
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
