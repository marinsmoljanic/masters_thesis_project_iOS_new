//
//  ProjectEditViewController.swift
//  ProjectManagement
//
//  Created by Marin Smoljanic on 1/4/21.
//

import UIKit

class ProjectEditViewController: UIViewController {
    public var id: Int
    //public var name: String
    //public var desc: String
    //public var startDate: Int
    //public var endDate: Int
    
    required init?(coder aDecoder: NSCoder) {
        self.id = 0
        //self.name = "--empty--"
        //self.desc = "--empty--"
        //self.startDate = 0
        //self.endDate = 0

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("===================================")
        print(id)
        //print(name)
        //print(desc)
        //print(startDate)
        //print(endDate)
        print("===================================")
    }
    
   

}
