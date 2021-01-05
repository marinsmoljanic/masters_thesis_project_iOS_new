import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var personButton: UIButton!
    @IBOutlet weak var projectsButton: UIButton!
    @IBOutlet weak var roleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        personButton.layer.cornerRadius = 10
        projectsButton.layer.cornerRadius = 10
        roleButton.layer.cornerRadius = 10
    }
}

