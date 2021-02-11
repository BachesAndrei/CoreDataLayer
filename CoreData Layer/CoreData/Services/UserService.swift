//
//  UserService.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 12/01/2021.
//

import Foundation
import CoreData

protocol UserServiceProtocol {
    func getUsers() -> [User]
    func getUser(userId: UUID) -> User?
    func saveUser(user: User, completionHandler: @escaping ((Result<Bool, Error>) -> Void))
    func saveUsers(users: [User], completionHandler: @escaping ((Result<Bool, Error>) -> Void))
    func clear(completionHandler: @escaping ((Result<Bool, Error>) -> Void))
}

struct UserService: UserServiceProtocol {

    private let coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    let repository: UserRepository
    
    init(coreDataStack: CoreDataStack) {
        self.context = coreDataStack.getPrivateContext()
        self.repository = UserRepository(context: context)
        self.coreDataStack = coreDataStack
    }

    func clear(completionHandler: @escaping ((Result<Bool, Error>) -> Void)) {
        repository.clear()
        
        coreDataStack.saveContext(context: context) { saveResult in
            
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
                coreDataStack.saveContext(context: context) { saveResult in
                    
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
        
        coreDataStack.saveContext(context: context) { saveResult in
            
            if saveResult != nil {
                completionHandler(.failure(CoreDataError.contextSaveFailed))
            }
            
            completionHandler(.success(true))
        }
    }
}
