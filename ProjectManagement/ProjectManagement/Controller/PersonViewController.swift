//
//  PersonViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/2/21.
//

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


