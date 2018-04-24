//
//  CoreDataManager.swift
//  Core Data Contacts
//
//  Created by Puroof on 4/23/18.
//  Copyright © 2018 lithogen. All rights reserved.
//

import CoreData


// Singleton to handle ability to access persistentContainer even in closures
// Will live forever as long as app is alive, its properties will too
struct CoreDataManager {
    
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateCoreData")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}
