//
//  CoreDataStore.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import Foundation
import CoreData

class CoreDataStore {
    
    /// The name of the Persistent Container file name
    private let modelName = "CoreData_Layer"
    
    private init() { }
    
    static let sharedInstance = CoreDataStore()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)") }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    /// Generate a new private context
    func getPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.managedContext
        
        return privateContext
    }

    /// Common save method for both main and private contexts
    /// - Parameters:
    ///   - context: Context that needs to be saved
    ///   - completionHandler: Completion handler to receive eventual save errors
    func saveContext(context: NSManagedObjectContext, _ completionHandler: @escaping (_ error: Error?) -> ())  {
        if context.parent != nil {
            self.savePrivateContext(privateContext: context) {error in
                completionHandler(error)
            }
        } else {
            self.saveContext(forContext: context) {error in
                completionHandler(error)
            }
        }
    }
    
    
    /// Internal implementation to all changes made on a context
    /// - Parameters:
    ///   - context: Context that needs to be saved
    ///   - completionHandler: Completion handler to receive eventual save errors
    fileprivate func saveContext(forContext context: NSManagedObjectContext, _ completionHandler: @escaping (_ error: Error?) -> ()) {
        guard context.hasChanges else {
            completionHandler(nil)
            return
        }
                
        do {
            try context.save()
            completionHandler(nil)
        } catch {
            let nserror = error as NSError
            print("Error when saving !!! \(nserror.localizedDescription)")
            print("Callstack :")
            for symbol: String in Thread.callStackSymbols {
                print(" > \(symbol)")
            }
            
            completionHandler(error)
        }
    }
    
    /// Internal implementation to save all changes made on a private context
    /// - Parameters:
    ///   - context: Private context that needs to be saved
    ///   - completionHandler: Completion handler to receive eventual save errors
    fileprivate func savePrivateContext(privateContext: NSManagedObjectContext, _ completionHandler: @escaping (_ error: Error?) -> ()) {
        guard privateContext.hasChanges else {
            completionHandler(nil)
            return
        }
        
        //completion handlers can be replaced by privateContext.performAndWait {} blocks if save error don t need to be passed further
        
        self.saveContext(forContext: privateContext) { error in

            guard error == nil else {
                completionHandler(error)
                return
            }

            self.saveContext(forContext: privateContext.parent!) { error in
                completionHandler(error)
            }
        }
    }
}
