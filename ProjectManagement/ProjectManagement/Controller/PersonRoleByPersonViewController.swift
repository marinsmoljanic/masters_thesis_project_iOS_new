//
//  PersonRoleByPersonViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/20/21.
//

import UIKit

class PersonRoleByPersonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    public var personId: Int
    public var personName: String
    public var personRoleId: Int
    
    var db:DBHelper = DBHelper()
    

    var projects:[Projekt] = []
    var projectsIds:[Int] = []
    var projectsNames:[String] = []
    
    var roles:[Uloga] = []
    var rolesIds:[Int] = []
    var rolesNames:[String] = []
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var ProjectPicker: UIPickerView!
    @IBOutlet weak var RolePicker: UIPickerView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var deletePersonRole: UIButton!
    @IBOutlet weak var SaveChanges: UIButton!
    
    var selectedProjectLocation = 1000
    var selectedRoleLocation = 1000

    required init?(coder aDecoder: NSCoder) {
        self.personId = 0
        self.personName = "--empty--"
        self.personRoleId = 0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.personNameLabel.text = self.personName
        deletePersonRole.layer.cornerRadius = 10
        SaveChanges.layer.cornerRadius = 10

        self.ProjectPicker.delegate = self
        self.ProjectPicker.dataSource = self
        
        self.RolePicker.delegate = self
        self.RolePicker.dataSource = self
        
        projects = db.readProjekte()
        roles = db.readUloge()
        
        // Projects parsing
        for project in projects{
            projectsNames.append(project.getNazivProjekta())
            projectsIds.append(project.getSifProjekta())
        }
        
        // Roles parsing
        for role in roles{
            rolesNames.append(role.getNazUloge())
            rolesIds.append(role.getIdUloge())
        }

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        self.selectedProjectLocation = ProjectPicker.selectedRow(inComponent: 0)
        self.selectedRoleLocation = RolePicker.selectedRow(inComponent: 0)
        let selectedDate = self.DatePicker.date
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "dd/MM/YYYY"
        // Convert Date to String
        let formatedDate = dateFormatter.string(from: selectedDate)

        // create person role DB call
        self.db.updateUlogaOsobeByPerson(ulogaOsobe: UlogaOsobe(SifProjekta: projectsIds[selectedProjectLocation],
                                                                IdOsobe: self.personId,
                                                                IdUloge: rolesIds[selectedRoleLocation],
                                                                DatDodjele: formatedDate))
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        self.db.deleteUlogaOsobeByPerson(personId: self.personId)
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
        if pickerView == ProjectPicker{
            return projects.count
        }
        else {
            return roles.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ProjectPicker{
            return projectsNames[row]
        }
        else {
            return rolesNames[row]
        }
    }

}
