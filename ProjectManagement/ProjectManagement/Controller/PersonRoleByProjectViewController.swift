//
//  PersonRoleByProjectViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/20/21.
//

import UIKit

class PersonRoleByProjectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    public var projectId: Int
    public var projectName: String
    public var personRoleId: Int
    
    var db:DBHelper = DBHelper()

    var persons:[Osoba] = []
    var personsIds:[Int] = []
    var personsNames:[String] = []
    
    var roles:[Uloga] = []
    var rolesIds:[Int] = []
    var rolesNames:[String] = []
    
    @IBOutlet weak var ProjectNameLabel: UILabel!
    @IBOutlet weak var PersonPicker: UIPickerView!
    @IBOutlet weak var RolePicker: UIPickerView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var UpdateButton: UIButton!
    
    var selectedPersonLocation = 1000
    var selectedRoleLocation = 1000
    
    required init?(coder aDecoder: NSCoder) {
        self.projectId = 0
        self.projectName = "--empty--"
        self.personRoleId = 0
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        self.ProjectNameLabel.text = self.projectName
        DeleteButton.layer.cornerRadius = 10
        UpdateButton.layer.cornerRadius = 10
        
        self.PersonPicker.delegate = self
        self.PersonPicker.dataSource = self
        
        self.RolePicker.delegate = self
        self.RolePicker.dataSource = self
        
        persons = db.readOsobe()
        roles = db.readUloge()
        
        // Persons parsing
        for person in persons{
            personsNames.append(person.getImeOsobe() + " " + person.getPrezimeOsobe())
            personsIds.append(person.getIdOsobe())
        }
        
        // Roles parsing
        for role in roles{
            rolesNames.append(role.getNazUloge())
            rolesIds.append(role.getIdUloge())
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        self.db.deleteUlogaOsobeBySifProjekta(projectCode: self.projectId)
    }
    
    
    @IBAction func saveClick(_ sender: UIButton) {
        self.selectedPersonLocation = PersonPicker.selectedRow(inComponent: 0)
        self.selectedRoleLocation = RolePicker.selectedRow(inComponent: 0)
        let selectedDate = self.DatePicker.date
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        // Convert Date to String
        let formatedDate = dateFormatter.string(from: selectedDate)

        // create person role DB call
        self.db.updateUlogaOsobeByProject(ulogaOsobe: UlogaOsobe(SifProjekta: self.projectId,
                                                                IdOsobe: personsIds[selectedPersonLocation],
                                                                IdUloge: rolesIds[selectedRoleLocation],
                                                                DatDodjele: formatedDate))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == PersonPicker{
            return persons.count
        }
        else {
            return roles.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == PersonPicker{
            return personsNames[row]
        }
        else {
            return rolesNames[row]
        }
    }


}
