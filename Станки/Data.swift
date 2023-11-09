
import UIKit
import RealmSwift

//Сохранение при помощи Realm

let realm = try! Realm()

class MainDataRealm: Object {
    @objc dynamic var id = currentId
    @objc dynamic var type: String?
    @objc dynamic var name: String?
    @objc dynamic var power: String?
    @objc dynamic var manufacture: String?
    @objc dynamic var link: String?
    @objc dynamic var imageSelected: Bool = false
}

var currentData = 0

var currentId = 0

let defaults = UserDefaults.standard
func saveId() {
    defaults.set(currentId, forKey: "currentId")
}

func loadId(){
    currentId = defaults.integer(forKey: "currentId")
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


