
import UIKit

class AlertService {
    
    static func showAlert(vc: UIViewController, title: String, message: String, button: String) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: button, style: .default)
        
        controller.addAction(action)
        
        vc.present(controller, animated: true)
        
    }
}
