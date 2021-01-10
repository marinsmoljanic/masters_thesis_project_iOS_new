import UIKit

class PersonEditViewController: UIViewController {
    public var index: Int
    public var firstName: String
    public var secondName: String
    public var personalID: String
    
    var nameLabel: UILabel!
    var nameLabelValue: UILabel!
    var surnameLabel: UILabel!
    var surnameLabelValue: UILabel!
    var personalIDLabel: UILabel!
    var personalIDLabelValue: UILabel!

    var db:DBHelper = DBHelper()
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        self.index = 1
        self.firstName = "--empty--"
        self.secondName = "--empty--"
        self.personalID = "--empty--"
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let layout = view.layoutMarginsGuide
        // setupTableView()
        
        let nameLabel = UILabel()
        let nameLabelValue = UILabel()
        let surnameLabel = UILabel()
        let surnameLabelValue = UILabel()
        let personalIDLabel = UILabel()
        let personalIDLabelValue = UILabel()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        nameLabel.text = "Ime osobe"
        nameLabelValue.text = self.firstName
        surnameLabel.text = "Prezime osobe"
        surnameLabelValue.text = self.secondName
        personalIDLabel.text = "OIB"
        personalIDLabelValue.text = self.personalID
        view.addSubview(nameLabel)
        view.addSubview(nameLabelValue)
        view.addSubview(surnameLabel)
        view.addSubview(surnameLabelValue)
        view.addSubview(personalIDLabel)
        view.addSubview(personalIDLabelValue)
        view.addSubview(tableview)

        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: layout.topAnchor, constant:20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        nameLabel.textColor = UIColor.gray

        
        // Name Label Value
        nameLabelValue.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        nameLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        nameLabelValue.translatesAutoresizingMaskIntoConstraints = false
        nameLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // Surname Label
        surnameLabel.topAnchor.constraint(equalTo: nameLabelValue.bottomAnchor, constant:20).isActive = true
        surnameLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.textColor = UIColor.gray


        // Surname Label Value
        surnameLabelValue.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 20).isActive = true
        surnameLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        surnameLabelValue.translatesAutoresizingMaskIntoConstraints = false
        surnameLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // PersonalID Label
        personalIDLabel.topAnchor.constraint(equalTo: surnameLabelValue.bottomAnchor, constant:20).isActive = true
        personalIDLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        personalIDLabel.translatesAutoresizingMaskIntoConstraints = false
        personalIDLabel.textColor = UIColor.gray


        // PersonalID Label Value
        personalIDLabelValue.topAnchor.constraint(equalTo: personalIDLabel.bottomAnchor, constant: 20).isActive = true
        personalIDLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        personalIDLabelValue.translatesAutoresizingMaskIntoConstraints = false
        personalIDLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // Tablica Zaduzenja
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: personalIDLabelValue.bottomAnchor, constant: 20),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    @IBAction func editPerson(_ sender: Any) {
        let alert = UIAlertController(title: "Promjena osobnih podataka", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.text = self.firstName}
        alert.addTextField { (tf) in tf.text = self.secondName}
        alert.addTextField { (tf) in tf.text = self.personalID}

        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let firstName = alert.textFields![0].text,
                  let secondName = alert.textFields![1].text,
                  let personalID = alert.textFields![2].text
                  else { return }
            
            let osoba = Osoba(idOsobe: self.index, imeOsobe: firstName, prezimeOsobe: secondName, OIB: personalID)
            self.db.updatePersonByID(person: osoba)}
        
        let delete = UIAlertAction(title: "Obrisi", style: .destructive) { (_) in
            self.db.deleteOsobaByID(id: self.index)}
                
        alert.addAction(delete)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
}
