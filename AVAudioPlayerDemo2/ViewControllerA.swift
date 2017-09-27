

import Foundation
import UIKit

class ViewControllerA: UIViewController {
    var a = ""
    var b = ""
@IBOutlet weak var aLabel: UILabel!
@IBOutlet weak var bLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aLabel.text = a
        bLabel.text = b
        
    }
    @IBAction func returnToTop(segue: UIStoryboardSegue) {}
}
