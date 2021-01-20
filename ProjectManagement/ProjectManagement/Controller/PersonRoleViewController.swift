import UIKit

class PersonRoleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var db:DBHelper = DBHelper()
    
    var persons:[Osoba] = []
    var personsIds:[Int] = []
    var personsNames:[String] = []

    var projects:[Projekt] = []
    var projectsIds:[Int] = []
    var projectsNames:[String] = []
    
    var roles:[Uloga] = []
    var rolesIds:[Int] = []
    var rolesNames:[String] = []

    @IBOutlet weak var PersonPicker: UIPickerView!
    @IBOutlet weak var ProjectPicker: UIPickerView!
    @IBOutlet weak var RolePicker: UIPickerView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBOutlet weak var ConfirmButton: UIButton!
    
    
    var osobe = ["Marin", "Klara", "Dominik", "Dusko"]
    var projekti = ["Puntijarka", "Pleternica", "Diplomski", "Prevoditelj"]
    var uloge = ["Arhitekt", "Ilustrator", "Dizajner", "Programer"]
    var selectedPersonLocation = 1000
    var selectedProjectLocation = 1000
    var selectedRoleLocation = 1000

    override func viewDidLoad() {
        // Connect data:
        self.PersonPicker.delegate = self
        self.PersonPicker.dataSource = self
        
        self.ProjectPicker.delegate = self
        self.ProjectPicker.dataSource = self
        
        self.RolePicker.delegate = self
        self.RolePicker.dataSource = self
        
        ConfirmButton.layer.cornerRadius = 10
        
        persons = db.readOsobe()
        projects = db.readProjekte()
        roles = db.readUloge()
        
        // Persons parsing
        for person in persons{
            personsNames.append(person.getImeOsobe() + " " + person.getPrezimeOsobe())
            personsIds.append(person.getIdOsobe())
        }
        
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
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        self.selectedPersonLocation = PersonPicker.selectedRow(inComponent: 0)
        self.selectedProjectLocation = ProjectPicker.selectedRow(inComponent: 0)
        self.selectedRoleLocation = RolePicker.selectedRow(inComponent: 0)
        let selectedDate = self.DatePicker.date
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"
        // Convert Date to String
        let formatedDate = dateFormatter.string(from: selectedDate)
        
        print("-------------------------------------")
        print(personsIds[selectedPersonLocation])
        print(projectsIds[selectedProjectLocation])
        print(rolesIds[selectedRoleLocation])
        print(formatedDate)
        print("-------------------------------------")

        // create person role DB call
        self.db.insertUlogaOsobe(ulogaOsobe: UlogaOsobe(SifProjekta: projectsIds[selectedProjectLocation],
                                                        IdOsobe: personsIds[selectedPersonLocation],
                                                        IdUloge: rolesIds[selectedRoleLocation],
                                                        DatDodjele: formatedDate))

        /*
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let addPersonRoleDestination = storyboard.instantiateViewController(withIdentifier: "PersonEditViewController") as! PersonEditViewController
        addPersonRoleDestination.title = "Dodavanje zaduženja"
        
        /*
        destination.index = persons[indexPath.row].getIdOsobe()
        destination.firstName = persons[indexPath.row].getImeOsobe()
        destination.secondName = persons[indexPath.row].getPrezimeOsobe()
        destination.personalID = persons[indexPath.row].getOIBOsobe()
        */
        
        navigationController?.pushViewController(addPersonRoleDestination, animated: true)
        
        */
        
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
        
        if pickerView == PersonPicker {
            return persons.count
        }
        else if pickerView == ProjectPicker{
            return projects.count
        }
        else {
            return roles.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == PersonPicker {
            return personsNames[row]
        }
        else if pickerView == ProjectPicker{
            return projectsNames[row]
        }
        else {
            return rolesNames[row]
        }
    }

}
