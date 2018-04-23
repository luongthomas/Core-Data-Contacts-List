//
//  CreateCompanyController.swift
//  Core Data Contacts
//
//  Created by Puroof on 4/22/18.
//  Copyright © 2018 lithogen. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}



