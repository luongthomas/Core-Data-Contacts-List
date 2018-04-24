//
//  CreateCompanyController.swift
//  Core Data Contacts
//
//  Created by Puroof on 4/22/18.
//  Copyright © 2018 lithogen. All rights reserved.
//

import UIKit
import CoreData

// Custom Delegation
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    // Not tightly coupled, any other view controller can access this protocol's endpoint
    var delegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        
        // Enable Autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
    }
    
    @objc func handleSave() {
        print("Trying to save company...")
        
        // initialization of our Core Data stack
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        
        // Perform the save
        do {
            try context.save()
            
            // Success
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }

    private func setupUI() {
        let lightBlueBackgroundView = UIView()
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}



