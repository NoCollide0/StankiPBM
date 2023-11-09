
import UIKit
import RealmSwift

class NewVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageMainView: UIView!
    
    @IBOutlet weak var type: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var power: UITextField!
    
    @IBOutlet weak var manufacture: UITextField!
    
    @IBOutlet weak var link: UITextField!
    
    @IBOutlet weak var buttonView: UIView!
    
    var selectedImage: UIImage?
    
    var newData = MainDataRealm()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type.delegate = self
        name.delegate = self
        power.delegate = self
        manufacture.delegate = self
        link.delegate = self
        
        buttonView.layer.cornerRadius = 10
        imageMainView.layer.cornerRadius = 20
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    
    //Всё что касается выбора изображения
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            self.selectedImage = selectedImage 
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //Кнопка готово
    @IBAction func doneButtonTapped(_ sender: Any) {
        //Проверка выбрано ли изображение и сохранение
        if let image = selectedImage {
            newData.imageSelected = true
            saveImageToDirectory(image)
        } else {
            newData.imageSelected = false
            print("Пользователь не выбрал изображение")
        }
        
        if type.text?.trimmingCharacters(in: .whitespaces) == ""{
            newData.type = "Тип станка не введен"
        }else{
            newData.type = type.text?.trimmingCharacters(in: .whitespaces)
        }
        if name.text?.trimmingCharacters(in: .whitespaces) == ""{
            newData.name = "Имя станка не введено"
        }else{
            newData.name = name.text?.trimmingCharacters(in: .whitespaces)
        }
        if power.text?.trimmingCharacters(in: .whitespaces) == ""{
            newData.power = "Мощность не введна"
        }else{
            newData.power = power.text?.trimmingCharacters(in: .whitespaces)
        }
        if manufacture.text?.trimmingCharacters(in: .whitespaces) == ""{
            newData.manufacture = "Изготовитель не введен"
        }else{
            newData.manufacture = manufacture.text?.trimmingCharacters(in: .whitespaces)
        }
        if link.text?.trimmingCharacters(in: .whitespaces) == ""{
            newData.link = ""
        }else{
            newData.link = link.text?.trimmingCharacters(in: .whitespaces)
        }
        
        do {
            try realm.write {
                realm.add(newData)
            }
        } catch {
            print("Ошибка при добавлении станка: \(error)")
        }
        
        currentId += 1
        saveId()
        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    
    //Функция сохранения картинки
    func saveImageToDirectory(_ image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
        let imageName = "\(newData.id).jpg"

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imagePath = dataDirectory.appendingPathComponent(imageName)
            do {
                try imageData.write(to: imagePath)
                print("Изображение сохранено в директории: \(imagePath)")
            } catch {
                print("Ошибка при сохранении изображения: \(error.localizedDescription)")
            }
        }
    }
    
    
    //Скрыть клавиатуру при нажатии готово
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Поднимаем клавиатуру
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height + 67
            
        }
        
    }

    //Опускаем Поднимаем клавиатуру
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}
