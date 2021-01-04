//
//  ProjectsViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/4/21.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    var db:DBHelper = DBHelper()
    var projects:[Projekt] = []
    
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
        
        projects = db.readProjekte()
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
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SingleProjectCell
        
        cell.backgroundColor = UIColor.white
        cell.personLabel.text = String(projects[indexPath.row].getNazivProjekta())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "PersonEditViewController") as! PersonEditViewController
        destination.title = "Projektni detalji"
        
        // destination.id = projects[indexPath.row].getSifProjekta()
        // destination.name = projects[indexPath.row].getNazivProjekta()
        // destination.desc = projects[indexPath.row].getOpisProjekta()
        // destination.startDate = projects[indexPath.row].getDatPoceta()
        // destination.endDate = projects[indexPath.row].getDatZavrsetka()

        navigationController?.pushViewController(destination, animated: true)
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
    
    @IBAction func addNewProjectButton(_ sender: Any) {
        let alert = UIAlertController(title: "Uneste novu osobu", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Naziv projekta"}
        alert.addTextField { (tf) in tf.placeholder = "Opis projekta"}
        alert.addTextField { (tf) in tf.placeholder = "Datum pocetka"}
        alert.addTextField { (tf) in tf.placeholder = "Datum zavrsetka"}

        // tu na textfieldsima treba skuzit kako uzeti tocno po redoslijedu
        alert.addAction(UIAlertAction(title: "Povratak", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Pohrani", style: .default) { (_) in
            guard let nazivProjekta = alert.textFields![0].text,
                let opisProjekta = alert.textFields![1].text,
                let datumPocetka = alert.textFields![2].text,
                let datumZavrsetka = alert.textFields![3].text
                
                else { return }

            let _datumPocetka = Int(datumPocetka)
            let _datumZavrsetka = Int(datumZavrsetka)

            let projekt = Projekt(SifProjekta: 0,
                                  NazProjekta: nazivProjekta,
                                  OpisProjekta: opisProjekta,
                                  DatPocetka: _datumPocetka!,
                                  DatZavrsetka: _datumZavrsetka!)
            self.db.insertProjekt(projekt: projekt)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
}
