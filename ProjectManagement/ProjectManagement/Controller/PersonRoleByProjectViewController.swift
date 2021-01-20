//
//  PersonRoleByProjectViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/20/21.
//

import UIKit

class PersonRoleByProjectViewController: UIViewController {
    public var projectId: Int
    public var projectName: String
    public var personRoleId: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.projectId = 0
        self.projectName = "--empty--"
        self.personRoleId = 0
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
