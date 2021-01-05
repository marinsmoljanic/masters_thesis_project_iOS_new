import UIKit

class ProjectEditViewController: UIViewController {
    public var id: Int
    public var name: String
    public var desc: String
    public var startDate: Int
    public var endDate: Int
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        self.id = 0
        self.name = "--empty--"
        self.desc = "--empty--"
        self.startDate = 0
        self.endDate = 0

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = self.name
        descLabel.text = self.desc
        startDateLabel.text = String(self.startDate)
        endDateLabel.text = String(self.endDate)
    }
    
   

}
