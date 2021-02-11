//
//  User.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import Foundation

struct User: Decodable {
    let id: UUID
    let name: String
    let favoriteDevice: Device?
    let devices: [Device]
    
    init(id: UUID, name: String, favoriteDevice: Device?, devices: [Device]) {
        self.id = id
        self.name = name
        self.favoriteDevice = favoriteDevice
        self.devices = devices
    }
    
    init(mo: UserMO) {
        
        //id and name can`t be null because these fields are not optionals in xcdatamodel
        self.id = mo.id!
        self.name = mo.name!
        
        self.favoriteDevice = Device(mo: mo.favoriteDevice)
        
        self.devices = mo.devices?.compactMap() {
            return Device(mo: ($0 as! DeviceMO))
        } ?? []
    }
}
