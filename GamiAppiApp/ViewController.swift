import UIKit
import LoyaltyStation

class ViewController: UIViewController {

    @IBOutlet weak var views: UIView!
    
    @IBAction func open(_ sender: Any) {
        LoyaltyStation.open(on: self)
    }
    
    @IBAction func login(_ sender: Any) {
        LoyaltyStation.login(user: User(id: "test-id", firstName: "Riyad", lastName: "Yahya", country: nil, referral: nil, hash: "237ccb1812cf2c893e341788921ec62515ca6d0507d7e4577055b25b794f831c"))
    }
}
