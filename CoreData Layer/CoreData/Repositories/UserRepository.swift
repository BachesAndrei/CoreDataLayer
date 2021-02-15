//
//  UserRepository.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import Foundation
import CoreData

class UserRepository: CoreDataRepository<UserMO> {
    private var deviceRepository: DeviceRepository
    
    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    init(context: NSManagedObjectContext) {
        self.deviceRepository = DeviceRepository(context: context)
        super.init(managedObjectContext: context)
    }
    
    /// Get all user objects saved on the persistence layer
    func getAllUsers() -> Result<[User]?, Error> {
        let result = self.get(predicate: nil, sortDescriptors: nil)
        switch result {
            case .success(let usersMO):
                let users = usersMO.map() {
                    return User(mo: $0)
                }
                
                return .success(users)
            case .failure(let error):
                return .failure(error)
        }
    }
    
    
    /// Get the user object with the specified UUID from the persistence layer
    /// - Parameter userId: The UUID to be searched
    func getUser(for userId: UUID) -> Result<User?, Error> {
        let predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        let result = self.get(predicate: predicate, sortDescriptors: nil)
        switch result {
            case .success(let usersMO):
                let users = usersMO.map() {
                    return User(mo: $0)
                }
                
                return .success(users.first)
            case .failure(let error):
                return .failure(error)
        }
    }
    
    
    /// Adds a new user object to the persistence layer
    /// - Parameter user: User object to be added
    @discardableResult func add(user: User?) -> Result<Bool, CoreDataError> {
        guard let mo = self.create() else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        
        guard let user = user else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        
        mo.id = user.id
        mo.name = user.name
        
        if let deviceMO = deviceRepository.add(device: user.favoriteDevice) {
            mo.favoriteDevice = deviceMO
        }
        
        //if device fields would be mandatory:
        //        guard let deviceMO = deviceRepository.add(device: user.device) {
        //            return .failure(CoreDataError.invalidManagedObjectType)
        //        }
        //        mo.device = deviceMO
        
        mo.devices = NSSet(array: user.devices.compactMap() {
            return deviceRepository.add(device: $0)
        })
        
        return .success(true)
    }
}
