
import UIKit

class MainScreenVC: UIViewController {
    
    
    
    
    var vStackView: UIStackView!
    
    var scrollView: UIScrollView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultValues: [String: Any] = ["dataCounter":-1]
        UserDefaults.standard.register(defaults: defaultValues)
        
        
        loadData()
        addVStackView()
        addFirstView()
        if dataCounter != -1 {
            setupLoadViews()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        deleteSubviews()
        addVStackView()
        addFirstView()
        if dataCounter != -1 {
            setupLoadViews()
        }
    }
    
    
    
    
    func addVStackView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        
        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 15
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
                    scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),

                    vStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                    vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
                ])
    }
    
    func addFirstView() {
        
        let bigView = UIView()
        bigView.translatesAutoresizingMaskIntoConstraints = false
        bigView.backgroundColor = UIColor.systemGray5
        bigView.layer.cornerRadius = 20
        vStackView.addArrangedSubview(bigView)
        
        let createLabel = UILabel()
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        createLabel.text = "Добавить станок"
        createLabel.textColor = UIColor.darkGray
        createLabel.font = UIFont.systemFont(ofSize: 25)
        bigView.addSubview(createLabel)
        
        let createButton = UIButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitle(" ", for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        bigView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            bigView.topAnchor.constraint(equalTo: vStackView.topAnchor, constant: 0),
            bigView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor, constant: -5),
            bigView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 5),
            bigView.heightAnchor.constraint(equalToConstant: 150),
            
            createLabel.centerYAnchor.constraint(equalTo: bigView.centerYAnchor),
            createLabel.centerXAnchor.constraint(equalTo: bigView.centerXAnchor),
            
            createButton.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 0),
            createButton.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 0),
            createButton.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: 0),
        ])
    }
    
    
    
    
    func setupLoadViews() {
        for i in 0...dataCounter {
            let bigView = UIView()
            bigView.translatesAutoresizingMaskIntoConstraints = false
            bigView.backgroundColor = UIColor.systemGray5
            bigView.layer.cornerRadius = 20
            vStackView.addArrangedSubview(bigView)
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if mainDataArray[i].imageSelected == true {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
                imageView.image = UIImage(contentsOfFile: dataDirectory.appendingPathComponent("\(i).jpg").path)
            } else {
                imageView.image = UIImage(named: "defaultStanok")
            }
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            bigView.addSubview(imageView)
            
            let type = UILabel()
            type.font = UIFont(name: "System", size: 12)
            type.text = mainDataArray[i].type
            type.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(type)
            
            let name = UILabel()
            name.font = UIFont(name: "System", size: 12)
            name.text = mainDataArray[i].name
            name.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(name)
            
            let power = UILabel()
            power.font = UIFont(name: "System", size: 12)
            power.text = mainDataArray[i].power
            power.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(power)
            
            let manufacture = UILabel()
            manufacture.font = UIFont(name: "System", size: 12)
            manufacture.text = mainDataArray[i].manufacture
            manufacture.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(manufacture)
            
            let link = UILabel()
            link.font = UIFont(name: "System", size: 12)
            if mainDataArray[i].link == "" {
                link.text = "Документация: нет"
            }else{
                link.text = "Документация: есть"
            }
            link.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(link)
            
            //Общую кнопку сюда
            let currentDataButton = UIButton()
            currentDataButton.translatesAutoresizingMaskIntoConstraints = false
            currentDataButton.setTitle(" ", for: .normal)
            currentDataButton.tag = i
            currentDataButton.addTarget(self, action: #selector(currentDataButtonTapped), for: .touchUpInside)
            bigView.addSubview(currentDataButton)
            
            let deleteView = UIView()
            deleteView.translatesAutoresizingMaskIntoConstraints = false
            deleteView.layer.cornerRadius = 12.5
            deleteView.backgroundColor = UIColor.systemRed
            deleteView.clipsToBounds = true
            deleteView.layer.masksToBounds = true
            bigView.addSubview(deleteView)
            
            let crossView = CrossView()
            crossView.translatesAutoresizingMaskIntoConstraints = false
            crossView.backgroundColor = UIColor.systemGray5
            deleteView.addSubview(crossView)
            
            let deleteButton = UIButton()
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.setTitle(" ", for: .normal)
            deleteButton.tag = i
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            deleteView.addSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                bigView.topAnchor.constraint(equalTo: vStackView.arrangedSubviews[i].bottomAnchor, constant: 15),
                bigView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor, constant: -5),
                bigView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 5),
                bigView.heightAnchor.constraint(equalToConstant: 150),
                
                imageView.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 20),
                imageView.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 10),
                imageView.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: -20),
                imageView.widthAnchor.constraint(equalToConstant: 160),
                
                type.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 21),
                type.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                type.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                type.heightAnchor.constraint(equalToConstant: 20),
                
                name.topAnchor.constraint(equalTo: type.bottomAnchor, constant: 2),
                name.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                name.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                name.heightAnchor.constraint(equalToConstant: 20),
                
                power.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2),
                power.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                power.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                power.heightAnchor.constraint(equalToConstant: 20),

                manufacture.topAnchor.constraint(equalTo: power.bottomAnchor, constant: 2),
                manufacture.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                manufacture.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                manufacture.heightAnchor.constraint(equalToConstant: 20),
                
                link.topAnchor.constraint(equalTo: manufacture.bottomAnchor, constant: 2),
                link.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                link.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                link.heightAnchor.constraint(equalToConstant: 20),
                
                currentDataButton.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 0),
                currentDataButton.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 0),
                currentDataButton.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: 0),
                currentDataButton.leadingAnchor.constraint(equalTo: bigView.leadingAnchor, constant: 0),
                
                deleteView.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 10),
                deleteView.trailingAnchor.constraint(equalTo: bigView.trailingAnchor, constant: -10),
                deleteView.widthAnchor.constraint(equalToConstant: 25),
                deleteView.heightAnchor.constraint(equalToConstant: 25),
                
                crossView.topAnchor.constraint(equalTo: deleteView.topAnchor, constant: 0),
                crossView.bottomAnchor.constraint(equalTo: deleteView.bottomAnchor, constant: 0),
                crossView.trailingAnchor.constraint(equalTo: deleteView.trailingAnchor, constant: 0),
                crossView.leadingAnchor.constraint(equalTo: deleteView.leadingAnchor, constant: 0),

                deleteButton.topAnchor.constraint(equalTo: deleteView.topAnchor, constant: 0),
                deleteButton.bottomAnchor.constraint(equalTo: deleteView.bottomAnchor, constant: 0),
                deleteButton.trailingAnchor.constraint(equalTo: deleteView.trailingAnchor, constant: 0),
                deleteButton.leadingAnchor.constraint(equalTo: deleteView.leadingAnchor, constant: 0),
            ])
        }
    }
    
    func deleteSubviews(){
        for subview in vStackView.subviews {
                subview.removeFromSuperview()
            }
    }
    
    
    
    //Кнопка создания
    @objc func createButtonTapped(){
        performSegue(withIdentifier: "toCreateNewVC", sender: nil)
    }
    
    //Кнопка просмотра
    @objc func currentDataButtonTapped(sender:UIButton) {
        performSegue(withIdentifier: "toCurrentDataVC", sender: nil)
        currentData = sender.tag
    }
    
    //Кнопка удаления
    @objc func deleteButtonTapped(sender:UIButton) {
        let alertController = UIAlertController(title: "Удаление", message: "Вы действительно хотите удалить станок?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Да", style: .destructive) { (action) in
            //удаление картинки
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
            do {
                try FileManager.default.removeItem(at: dataDirectory.appendingPathComponent("\(sender.tag).jpg"))
                print("Файл успешно удален")
            } catch {
                print("Ошибка при удалении файла: \(error)")
            }
            mainDataArray.remove(at: sender.tag)
            dataCounter -= 1
            self.deleteSubviews()
            self.addVStackView()
            self.addFirstView()
            if dataCounter != -1 {
                self.setupLoadViews()
            }
            saveData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}


