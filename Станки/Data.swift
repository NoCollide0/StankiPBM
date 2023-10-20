
import UIKit

//Сохранение при помощи UserDefaults
let defaults = UserDefaults.standard


final class MainData: Codable {
    var type: String?
    var name: String?
    var power: String?
    var manufacture: String?
    var link: String?
    var imageSelected: Bool = false
}

var dataCounter: Int! = -1

var mainDataArray = [MainData]()

var currentData: Int! = 0




// Функция для сохранения данных
func saveData() {
    defaults.set(dataCounter, forKey: "dataCounter")
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        do {
            let data = try PropertyListEncoder().encode(mainDataArray)
            try data.write(to: documentsDirectory.appendingPathComponent("mainDataArray.plist"))
            print("Данные сохранены успешно")
        } catch {
            print("Ошибка при сохранении данных: \(error.localizedDescription)")
        }
    }
}

// Функция для загрузки данных
func loadData() {
    dataCounter = defaults.integer(forKey: "dataCounter")
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        do {
            let data = try Data(contentsOf: documentsDirectory.appendingPathComponent("mainDataArray.plist"))
            mainDataArray = try PropertyListDecoder().decode([MainData].self, from: data)
            print("Данные загружены успешно")
        } catch {
            print("Ошибка при загрузке данных: \(error.localizedDescription)")
        }
    }
}




//Рисуем крестик
class CrossView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(2.0) // Толщина линий креста
            context.setStrokeColor(UIColor.darkGray.cgColor) // Цвет линий креста
            
            // Первая диагональная линия
            context.move(to: CGPoint(x: 0, y: 0))
            context.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
                        
            // Вторая диагональная линия
            context.move(to: CGPoint(x: 0, y: rect.size.height))
            context.addLine(to: CGPoint(x: rect.size.width, y: 0))
            
            context.strokePath()
        }
    }
}


