//
//  DeviceRepository.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import Foundation
import CoreData

class DeviceRepository {
    private let repository: CoreDataRepository<DeviceMO>
    
    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<DeviceMO>(managedObjectContext: context)
    }
    
    @discardableResult func add(device: Device?) -> DeviceMO? {
        guard let device = device else {
            return nil
        }
        
        guard let mo = repository.create() else {
            return nil
        }

        mo.name = device.name
        mo.type = Int16(device.type.rawValue)

        return mo
    }
}
