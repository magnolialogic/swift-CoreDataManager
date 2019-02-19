//
//  CoreDataManager.swift
//
//  Created by Chris Coffin on 2/27/18.
//  Copyright © 2018 Chris Coffin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Private init to prevent clients from creating another instance
    private init() {}
    
    // Create shared instance
    static let sharedManager = CoreDataManager()
    
    // Create shared reference for managed context
    lazy var managedContext: NSManagedObjectContext = {
        return CoreDataManager.sharedManager.persistentContainer.viewContext
    }()
    
    // Create shared reference for persistent container "testApp"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "testApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Create shared FRC for TestItems, sorted by "testKey"
    lazy var itemsFetchedResultsController: NSFetchedResultsController<TestItems> = {
        let fetchRequest = TestItems.createFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "testKey", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // Commit changes made to managed context
    func saveContext() {
        print(#function)
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}