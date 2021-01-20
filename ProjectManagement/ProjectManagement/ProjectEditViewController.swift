import UIKit

class ProjectEditViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource  {
    public var id: Int
    public var name: String
    public var desc: String
    public var startDate: String
    public var endDate: String
  
    
    var projectNameLabel: UILabel!
    var projectNameLabelValue: UILabel!
    var descriptionLabel: UILabel!
    var descriptionLabelValue: UILabel!
    var startDateLabel: UILabel!
    var startDateLabelValue: UILabel!
    var endDateLabel: UILabel!
    var endDateLabelValue: UILabel!

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
        self.id = 1
        self.name = "--empty--"
        self.desc = "--empty--"
        self.startDate = "--empty--"
        self.endDate = "--empty--"
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let layout = view.layoutMarginsGuide
        handlePersonRoles()
        
        let projectNameLabel = UILabel()
        let projectNameLabelValue = UILabel()
        let descriptionLabel = UILabel()
        let descriptionLabelValue = UILabel()
        let startDateLabel = UILabel()
        let startDateLabelValue = UILabel()
        let endDateLabel = UILabel()
        let endDateLabelValue = UILabel()


        projectNameLabel.text = "Naziv projekta"
        projectNameLabelValue.text = self.name
        descriptionLabel.text = "Opis projekta"
        descriptionLabelValue.text = self.desc
        startDateLabel.text = "Datum početka"
        startDateLabelValue.text = self.startDate
        endDateLabel.text = "Datum završetka"
        endDateLabelValue.text = self.endDate

        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        view.addSubview(projectNameLabel)
        view.addSubview(projectNameLabelValue)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionLabelValue)
        view.addSubview(startDateLabel)
        view.addSubview(startDateLabelValue)
        view.addSubview(endDateLabel)
        view.addSubview(endDateLabelValue)
        view.addSubview(tableview)

        // Name Label
        projectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectNameLabel.topAnchor.constraint(equalTo: layout.topAnchor, constant:20).isActive = true
        projectNameLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        projectNameLabel.textColor = UIColor.gray

        
        // Name Label Value
        projectNameLabelValue.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 20).isActive = true
        projectNameLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        projectNameLabelValue.translatesAutoresizingMaskIntoConstraints = false
        projectNameLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // Desc Label
        descriptionLabel.topAnchor.constraint(equalTo: projectNameLabelValue.bottomAnchor, constant:20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = UIColor.gray


        // Desc Label Value
        descriptionLabelValue.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        descriptionLabelValue.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // Start date Label
        startDateLabel.topAnchor.constraint(equalTo: descriptionLabelValue.bottomAnchor, constant:20).isActive = true
        startDateLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.textColor = UIColor.gray


        // Start date Label Value
        startDateLabelValue.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 20).isActive = true
        startDateLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        startDateLabelValue.translatesAutoresizingMaskIntoConstraints = false
        startDateLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)
        
        // End date Label
        endDateLabel.topAnchor.constraint(equalTo: startDateLabelValue.bottomAnchor, constant:20).isActive = true
        endDateLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor).isActive = true
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.textColor = UIColor.gray


        // End date Label Value
        endDateLabelValue.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 20).isActive = true
        endDateLabelValue.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        endDateLabelValue.translatesAutoresizingMaskIntoConstraints = false
        endDateLabelValue.font = UIFont(name:"HelveticaNeue-Bold", size: 22.0)


        // Tablica Zaduzenja
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.register(PersonRoleCell.self, forCellReuseIdentifier: "cellId")
        
        tableview.topAnchor.constraint(equalTo: endDateLabelValue.bottomAnchor, constant: 20).isActive = true
        tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    }
    
    func handlePersonRoles(){
        personRolesTmp = db.readAllUlogaOsoba()
        for personRole in personRolesTmp {
            if personRole.getSifProjekta() == self.id {
                personRoles.append(personRole)
            }
        }
    }
    @IBAction func editProject(_ sender: Any) {
        let alert = UIAlertController(title: "Promjena podataka projekta", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.text = self.name}
        alert.addTextField { (tf) in tf.text = self.desc}
        alert.addTextField { (tf) in tf.text = self.startDate}
        alert.addTextField { (tf) in tf.text = self.endDate}

        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let name = alert.textFields![0].text,
                  let desc = alert.textFields![1].text,
                  let startDate = alert.textFields![2].text,
                  let endDate = alert.textFields![3].text
                  else { return }
            
            let project = Projekt(SifProjekta: self.id, NazProjekta: name, OpisProjekta: desc, DatPocetka: startDate, DatZavrsetka: endDate)
            self.db.updateProjectByID(project: project)
            
        }
        
        let delete = UIAlertAction(title: "Obriši", style: .destructive) { (_) in
            self.db.deleteProjektByID(id: self.id)}
                
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
            let datDodjele = String(personRoles[indexPath.row].getDatDodjele())
            cell.personRoleLabel.text = String("OSOBA:   " + personRoles[indexPath.row].getImeOsobe() + " " + personRoles[indexPath.row].getPrezimeOsobe() + "\n" +
                                                "ULOGA:    " + personRoles[indexPath.row].getNazUloge() + "\n" +
                                                "DATUM:    " + datDodjele)
        }
        else {
            cell.personRoleLabel.text = "+ Dodaj novo zaduženje"
            cell.cellView.backgroundColor = UIColor.orange
            cell.personRoleLabel.textAlignment = .center
            cell.personRoleLabel.centerXAnchor.constraint(equalTo: cell.cellView.centerXAnchor).isActive = true
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == personRoles.count){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let addPersonRoleDestination = storyboard.instantiateViewController(withIdentifier: "PersonRoleViewController") as! PersonRoleViewController
            addPersonRoleDestination.title = "Dodavanje zaduženja"
            
            navigationController?.pushViewController(addPersonRoleDestination, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "PersonRoleByProjectViewController") as! PersonRoleByProjectViewController
            destination.title = "Uredi zaduženje projekta"
            
            destination.projectId = self.id
            destination.personRoleId = 0 // OVDJE dohvatiti id zaduzenja
            destination.projectName = self.name

            navigationController?.pushViewController(destination, animated: true)
        }


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
            label.numberOfLines = 3
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
