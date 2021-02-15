//
//  UserService.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 12/01/2021.
//

import Foundation
import CoreData


//Protocol to expose open methods. Can be used to create a different custom UserService in case of UnitTesting
protocol UserServiceProtocol {
    func getUsers() -> [User]
    func getUser(userId: UUID) -> User?
    func saveUser(user: User, completionHandler: @escaping ((Result<Bool, Error>) -> Void))
    func saveUsers(users: [User], completionHandler: @escaping ((Result<Bool, Error>) -> Void))
    func clear(completionHandler: @escaping ((Result<Bool, Error>) -> Void))
}

struct UserService: UserServiceProtocol {

    ///CoreDataStore objected needed to provide
    private let coreDataStore: CoreDataStore
    
    ///The NSManagedObjectContext instance to be used for performing all the changes
    private let context: NSManagedObjectContext
    
    let repository: UserRepository
    
    init(coreDataStore: CoreDataStore) {
        self.coreDataStore = coreDataStore
        self.context = coreDataStore.getPrivateContext()
        self.repository = UserRepository(context: context)
    }

    func clear(completionHandler: @escaping ((Result<Bool, Error>) -> Void)) {
        repository.clear()
        
        coreDataStore.saveContext(context: context) { saveResult in
            
            if saveResult != nil {
                completionHandler(.failure(CoreDataError.contextSaveFailed))
            }
            
            completionHandler(.success(true))
        }
    }
    
    func getUsers() -> [User] {
        guard let users = try? repository.getAllUsers().get() else {
            return []
        }
        
        return users
    }
    
    func getUser(userId: UUID) -> User? {
        guard let user = try? repository.getUser(for: userId).get() else {
            return nil
        }
        
        return user
    }
    
    func saveUser(user: User, completionHandler: @escaping ((Result<Bool, Error>) -> Void)) {
        let insertionResult = repository.add(user: user)
        
        switch insertionResult {
            case .success(_):
                coreDataStore.saveContext(context: context) { saveResult in
                    
                    if saveResult != nil {
                        completionHandler(.failure(CoreDataError.contextSaveFailed))
                    }
                    
                    completionHandler(.success(true))
                }
            default:
                completionHandler(.failure(CoreDataError.invalidManagedObjectType))
        }
    }
    
    
    func saveUsers(users: [User], completionHandler: @escaping ((Result<Bool, Error>) -> Void)) {
        users.forEach() { user in
            let insertionResult = repository.add(user: user)
            
            guard let _ = try? insertionResult.get() else {
                self.context.undo()
                completionHandler(.failure(CoreDataError.invalidManagedObjectType))
                return
            }
        }
        
        coreDataStore.saveContext(context: context) { saveResult in
            
            if saveResult != nil {
                completionHandler(.failure(CoreDataError.contextSaveFailed))
            }
            
            completionHandler(.success(true))
        }
    }
}
