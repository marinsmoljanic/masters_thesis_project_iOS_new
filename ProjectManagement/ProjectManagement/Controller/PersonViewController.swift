import UIKit

class PersonViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    var db:DBHelper = DBHelper()
    var persons:[Osoba] = []
    
    let tableview: UITableView = {
           let tv = UITableView()
           tv.backgroundColor = UIColor.white
           tv.translatesAutoresizingMaskIntoConstraints = false
           return tv
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        persons = db.readOsobe()
    }

    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.register(SinglePersonCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SinglePersonCell
        
        cell.backgroundColor = UIColor.white
        cell.personLabel.text = String(persons[indexPath.row].getImeOsobe() + " " + persons[indexPath.row].getPrezimeOsobe())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "PersonEditViewController") as! PersonEditViewController
        destination.title = "Detalji osobe"
        
        destination.index = persons[indexPath.row].getIdOsobe()
        destination.firstName = persons[indexPath.row].getImeOsobe()
        destination.secondName = persons[indexPath.row].getPrezimeOsobe()
        destination.personalID = persons[indexPath.row].getOIBOsobe()

        navigationController?.pushViewController(destination, animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    class SinglePersonCell: UITableViewCell {
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBlue
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let personLabel: UILabel = {
            let label = UILabel()
            label.text = "Person 1"
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
            cellView.addSubview(personLabel)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            personLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            personLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            personLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            personLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        }
        
    }
    
    @IBAction func addNewPerson(_ sender: Any) {
        let alert = UIAlertController(title: "Unesite novu osobu", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Prezime"}
        alert.addTextField { (tf) in tf.placeholder = "Ime"}
        alert.addTextField { (tf) in tf.placeholder = "OIB"}

        // tu na textfieldsima treba naci kako uzeti tocno po redoslijedu
        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let ime = alert.textFields![0].text,
                let prezime = alert.textFields![1].text,
                let OIB = alert.textFields![2].text

                else { return }
            
            print(ime)
            print(prezime)
            print(OIB)
            
            let osoba = Osoba(idOsobe: 0,imeOsobe: ime, prezimeOsobe: prezime, OIB: OIB)
            self.db.insertOsoba(osoba: osoba)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
}

/*
import UIKit

class PersonViewController: UIViewController {
    
    @IBOutlet var PersonTableViewOutlet: UITableView!
    
    var db:DBHelper = DBHelper()
    var osobe:[Osoba] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        osobe = db.readOsobe()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    
    
}

extension PersonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let vc = PersonEditViewController(personName: "Marin")
        //vc.title = "Master details"
        //navigationController?.pushViewController(ViewController(), animated: true)
        
        
        //var view: UIStoryboard!
        //view = UIStoryboard(name: "Main", bundle: nil)

        //let sample = view.instantiateViewController(withIdentifier: "personEdit") as! PersonEditViewController

        //sample.personName = "Moja osoba"
        //self.navigationController?.pushViewController(sample, animated: true)
        
        
        // ___________________________________________________________
        //let destination = UIViewController() // Your destination
        //navigationController?.pushViewController(destination, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "PersonEditViewController") as! PersonEditViewController
        destination.title = "Master Details"
        
        // let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        // print(cell.textLabel?.text)
        
        destination.index = indexPath.row

        navigationController?.pushViewController(destination, animated: true)
    }
}

extension PersonViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Broj Osoba IZ extensiona")
        print(osobe.count)
        
        return osobe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(osobe[indexPath.row].getIdOsobe()) + " " +
                               String(osobe[indexPath.row].getPrezimeOsobe()) + " " +
                               String(osobe[indexPath.row].getImeOsobe()) + " " +
                               String(osobe[indexPath.row].getOIBOsobe())
        
        return cell
    }
}

*/
