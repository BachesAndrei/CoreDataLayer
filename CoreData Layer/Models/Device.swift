//
//  Device.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import Foundation

struct Device: Decodable {
    let name: String
    let type: DeviceType
    
    init(name: String, type: DeviceType) {
        self.name = name
        self.type = type
    }
    
    init?(mo: DeviceMO?) {
        guard let mo = mo else {
            return nil
        }
        
        //name and type can`t be null because these fields are not optionals in xcdatamodel
        self.name = mo.name!
        self.type = DeviceType(rawValue: Int(mo.type)) ?? .phone
    }
}
