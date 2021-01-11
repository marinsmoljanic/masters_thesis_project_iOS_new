import UIKit

class PersonEditViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
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
    var personRoles:[UlogaOsobeEnriched] = []
    var personRolesTmp:[UlogaOsobeEnriched] = []

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
        handlePersonRoles()
        
        let nameLabel = UILabel()
        let nameLabelValue = UILabel()
        let surnameLabel = UILabel()
        let surnameLabelValue = UILabel()
        let personalIDLabel = UILabel()
        let personalIDLabelValue = UILabel()

        nameLabel.text = "Ime osobe"
        nameLabelValue.text = self.firstName
        surnameLabel.text = "Prezime osobe"
        surnameLabelValue.text = self.secondName
        personalIDLabel.text = "OIB"
        personalIDLabelValue.text = self.personalID
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

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
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.register(PersonRoleCell.self, forCellReuseIdentifier: "cellId")
        
        tableview.topAnchor.constraint(equalTo: personalIDLabelValue.bottomAnchor, constant: 20).isActive = true
        tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    }
    
    func handlePersonRoles(){
        personRolesTmp = db.readAllUlogaOsoba()
        for personRole in personRolesTmp {
            if personRole.getIdOsobe() == self.index {
                personRoles.append(personRole)
            }
        }
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
    
    // Person-Role table utilities
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        let len = personRoles.count + 1
        return len
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PersonRoleCell
        cell.backgroundColor = UIColor.white

        if indexPath.row < personRoles.count{
            cell.personRoleLabel.text = String("PROJEKT:   " + personRoles[indexPath.row].getNazProjekta() + "\n" +
                                                "ULOGA:       " + personRoles[indexPath.row].getNazUloge())
        }
        else {
            cell.personRoleLabel.text = "+ Dodaj novo zaduzenje"
            cell.cellView.backgroundColor = UIColor.orange
            cell.personRoleLabel.textAlignment = .center
            cell.personRoleLabel.centerXAnchor.constraint(equalTo: cell.cellView.centerXAnchor).isActive = true
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        print("--------------------------------")
        print(String(indexPath.row))
        print("--------------------------------")

        /*  let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "PersonEditViewController") as! PersonEditViewController
        destination.title = "Detalji osobe"
        
        destination.index = persons[indexPath.row].getIdOsobe()
        destination.firstName = persons[indexPath.row].getImeOsobe()
        destination.secondName = persons[indexPath.row].getPrezimeOsobe()
        destination.personalID = persons[indexPath.row].getOIBOsobe()

        navigationController?.pushViewController(destination, animated: true)*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < personRoles.count{
         return 100
        }
        else {
          return 70
        }
    }
    
    class PersonRoleCell: UITableViewCell {
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBlue
            view.layer.cornerRadius = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let personRoleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 2
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {
            addSubview(cellView)
            cellView.addSubview(personRoleLabel)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            personRoleLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            personRoleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            personRoleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            personRoleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        }
    }
}
