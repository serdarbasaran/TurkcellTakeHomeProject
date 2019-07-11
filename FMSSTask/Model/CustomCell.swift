
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var benefitsLabel: UILabel!
    @IBOutlet weak var tariffLabel: UILabel!
    @IBOutlet weak var subscriptionTypeAndPriceLabel: UILabel!
    @IBOutlet weak var didUseBeforeLabel: UILabel!
    @IBOutlet weak var availableUntilLabel: UILabel!
    
    @IBOutlet weak var favStarButton: UIButton!
    
    override func awakeFromNib() { super.awakeFromNib()
        
        backView.layer.cornerRadius = 30
        
    }
}
