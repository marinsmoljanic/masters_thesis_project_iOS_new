import UIKit

class PersonEditViewController: UIViewController {
    public var index: Int
    public var firstName: String
    public var secondName: String
    public var personalID: String
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var personalIdLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        self.index = 1
        self.firstName = "--empty--"
        self.secondName = "--empty--"
        self.personalID = "--empty--"
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = self.firstName
        surnameLabel.text = self.secondName
        personalIdLabel.text = self.personalID
    }
    
    @IBAction func editPerson(_ sender: Any) {
        
        let alert = UIAlertController(title: "Uredi podatke uloga", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = String("Testna vrijednost")}
        
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let nazUloge = alert.textFields![0].text
                else { return }
           
            // let uloga = Uloga(SifProjekta: <#T##Int#>, NazProjekta: <#T##String#>, OpisProjekta: <#T##String#>, DatPocetka: <#T##Int#>, DatZavrsetka: <#T##Int#>)
            // tu se zove zapravo update, a ne insert
            // self.db.insertUloga(uloga: uloga)
        }
        
        let delete = UIAlertAction(title: "Obrisi", style: .destructive) { (_) in
        }
        
        let cancle = UIAlertAction(title: "Odustani", style: .cancel ) { (_) in
        }
        alert.addAction(action)
        alert.addAction(delete)
        alert.addAction(cancle)

        present(alert, animated: true, completion: nil)
    }
    
}
