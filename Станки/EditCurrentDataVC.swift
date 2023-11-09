

import UIKit
import RealmSwift

class EditCurrentDataVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageMainView: UIView!
    
    @IBOutlet weak var type: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var power: UITextField!
    
    @IBOutlet weak var manufacture: UITextField!
    
    @IBOutlet weak var link: UITextField!
    
    @IBOutlet weak var buttonView: UIView!
    
    var selectedImage: UIImage?
    
    var currentMachine = realm.objects(MainDataRealm.self).filter("id == %@", currentData).first
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForEdit()
        buttonView.layer.cornerRadius = 10
        imageMainView.layer.cornerRadius = 20
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    
    
    
    @objc func backButtonTapped() {
        showConfirmationAlert()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        saveDataAfterEdit()
        navigationController?.popViewController(animated: true)
    }
    
    //всё что касается сохранения картинки (и функция внизу)
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
    
    
    
    func loadDataForEdit() {
        
        type.delegate = self
        name.delegate = self
        power.delegate = self
        manufacture.delegate = self
        link.delegate = self
        
        if currentMachine!.imageSelected == true {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
            imageView.image = UIImage(contentsOfFile: dataDirectory.appendingPathComponent("\(currentData).jpg").path)
        } else {
            imageView.image = UIImage(named: "defaultStanok")
        }
        
        type.text = currentMachine!.type
        name.text = currentMachine!.name
        power.text = currentMachine!.power
        manufacture.text = currentMachine!.manufacture
        link.text = currentMachine!.link
    }
    
    func saveDataAfterEdit() {
        do {
            try realm.write {
                currentMachine!.imageSelected = true
                if let image = selectedImage {
                    saveImageToDirectory(image)
                } else {
                    currentMachine!.imageSelected = false
                    print("Пользователь не выбрал изображение")
                }
                if type.text?.trimmingCharacters(in: .whitespaces) == ""{
                        currentMachine!.type = "Тип станка не введен"
                    }else{
                        currentMachine!.type = type.text?.trimmingCharacters(in: .whitespaces)
                    }
                    if name.text?.trimmingCharacters(in: .whitespaces) == ""{
                        currentMachine!.name = "Имя станка не введено"
                    }else{
                        currentMachine!.name = name.text?.trimmingCharacters(in: .whitespaces)
                    }
                    if power.text?.trimmingCharacters(in: .whitespaces) == ""{
                        currentMachine!.power = "Мощность не введена"
                    }else{
                        currentMachine!.power = power.text?.trimmingCharacters(in: .whitespaces)
                    }
                    if manufacture.text?.trimmingCharacters(in: .whitespaces) == ""{
                        currentMachine!.manufacture = "Изготовитель не введен"
                    }else{
                        currentMachine!.manufacture = manufacture.text?.trimmingCharacters(in: .whitespaces)
                    }
                    if link.text?.trimmingCharacters(in: .whitespaces) == ""{
                        currentMachine!.link = ""
                    }else{
                        currentMachine!.link = link.text?.trimmingCharacters(in: .whitespaces)
                    }
            }
        } catch {
            print("Ошибка при обновлении станка: \(error)")
        }
    }
    
    
    func showConfirmationAlert() {
        let alertController = UIAlertController(title: "Сохранение", message: "Сохранить изменения?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        let negativeAction = UIAlertAction(title: "Нет", style: .destructive) { (action) in
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }
        let positiveAction = UIAlertAction(title: "Да", style: .destructive) { (action) in
            self.saveDataAfterEdit()
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(positiveAction)
        alertController.addAction(negativeAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    //Функция сохранения картинки
    func saveImageToDirectory(_ image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataDirectory = documentsDirectory.appendingPathComponent("pbmStankiApp")
        let imageName = "\(currentData).jpg"

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
