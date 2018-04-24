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
        
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue

        // so non-cells area will not have lines
        tableView.tableFooterView = UIView()
        
        tableView.separatorColor = .white
        
        // Required to render out and dequeue reusablecells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
    }

    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = UINavigationController(rootViewController: createCompanyController)

        createCompanyController.delegate = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let company = companies[indexPath.row]
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    
}

