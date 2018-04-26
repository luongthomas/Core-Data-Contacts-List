//
//  CompaniesController.swift
//  Core Data Contacts
//
//  Created by Puroof on 4/22/18.
//  Copyright © 2018 lithogen. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        // 1 - Modify Array
        companies.append(company)
        
        // 2 - Insert a new index into tableView
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        // Update tableview
        if let row = companies.index(of: company) {
            let reloadIndexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [reloadIndexPath], with: .middle)
        }
    }
    
    let cellId = "cellId"
    var companies = [Company]()
    
    private func fetchCompanies() {
        // initialization of our Core Data stack
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // Fetch and automatically turn it into a Company Object
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            
            companies.forEach { (company) in
                print(company.name ?? "")
            }
            
            // set data of tableView and then reload
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue

        // so non-cells area will not have lines
        tableView.tableFooterView = UIView()
        
        tableView.separatorColor = .white
        
        // Required to render out and dequeue reusablecells
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
    }

    @objc func handleReset() {
        print("Attempting to delete all core data objects")
        // Remove elements from table and animate the removal so it shifts to the left
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            
            // Upon deletion from core data succeeded
            var indexPathToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
        
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
            
            
//            tableView.reloadData()
            
            
        } catch let delErr {
            print("Failed to delete objects from Core Data: ", delErr)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Footers center their content vertically, change the height and the font will go down
        return companies.count == 0 ? 150 : 0
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = UINavigationController(rootViewController: createCompanyController)

        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company:", company.name ?? "")
            
            // remove the company from our tableView
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company: ", saveErr)
            }
        }
        
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)

        deleteAction.backgroundColor = UIColor.lightRed
        editAction.backgroundColor = UIColor.darkBlue
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate function")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        
        present(navController, animated: true, completion: nil)
    }
    
    // Header code
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    
}

