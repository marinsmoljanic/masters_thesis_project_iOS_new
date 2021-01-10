import UIKit

class RoleViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    var db:DBHelper = DBHelper()
    var roles:[Uloga] = []
    
    let tableview: UITableView = {
           let tv = UITableView()
           tv.backgroundColor = UIColor.white
           tv.separatorColor = UIColor.green
           tv.translatesAutoresizingMaskIntoConstraints = false
           return tv
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        roles = db.readUloge()
    }

    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.register(SingleProjectCell.self, forCellReuseIdentifier: "cellId")
        
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
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SingleProjectCell
        
        cell.backgroundColor = UIColor.white
        cell.roleLabel.text = String(roles[indexPath.row].getNazUloge())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let alert = UIAlertController(title: "Promjena uloge", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.text = String(self.roles[indexPath.row].getNazUloge())}

        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let nazivUloge = alert.textFields![0].text
                  else { return }
            
            self.db.updateUlogaByID(id: self.roles[indexPath.row].getIdUloge(),
                                    naziv: nazivUloge)}
        
        let delete = UIAlertAction(title: "Obrisi", style: .destructive) { (_) in
            self.db.deleteUlogaByID(id: self.roles[indexPath.row].getIdUloge())}
                
        alert.addAction(delete)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    class SingleProjectCell: UITableViewCell {
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBlue
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let roleLabel: UILabel = {
            let label = UILabel()
            label.text = "Role 1"
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
            cellView.addSubview(roleLabel)
            self.selectionStyle = .none
            
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            roleLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            roleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            roleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            roleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        }
    }
    
    @IBAction func addNewRole(_ sender: Any) {
        let alert = UIAlertController(title: "Unos nove uloge", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Naziv uloge"}
      
        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let nazivUloge = alert.textFields![0].text
                  else { return }
            
            self.db.insertUloga(nazUloge: nazivUloge)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
