//
//  PersonEditViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/2/21.
//

import UIKit

class PersonEditViewController: UIViewController {
    public var index: Int
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var personalIdLabel: UILabel!
    
    //init(personName: String){
    //    self.personName = personName
    //    super.init(nibName: nil, bundle: nil)
   // }
    
    required init?(coder aDecoder: NSCoder) {
        self.index = 1
        super.init(coder: aDecoder)
    }
    
    //required init?(coder: NSCoder) {
    //   fatalError("init(coder:) has not been implemented")
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Marin"
        surnameLabel.text = "Smoljanic"
        personalIdLabel.text = "38448491183"
        print("----------------")
        print(index)
        print("----------------")
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
