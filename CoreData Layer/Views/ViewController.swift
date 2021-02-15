//
//  ViewController.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import UIKit

class ViewController: UIViewController {

    
    let userService = UserService(coreDataStore: CoreDataStore.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userService.getUsers())
    }


    func testSaveUsers() {
        let laptopDevice = Device(name: "test laptop", type: .laptop)
        let phoneDevice = Device(name: "test phone", type: .phone)
        
        let phoneUser = User(id: UUID(), name: "phone user", favoriteDevice: phoneDevice, devices: [laptopDevice, phoneDevice])
        let laptopUser = User(id: UUID(), name: "laptop user", favoriteDevice: laptopDevice, devices: [laptopDevice, phoneDevice])
        let user = User(id: UUID(), name: "no device user", favoriteDevice: nil, devices: [])
        
        
        userService.saveUser(user: phoneUser) { _ in
            print(self.userService.getUsers())
        }
    }
    
    func testRemoveUsers() {
        userService.clear() {_ in
            print(self.userService.getUsers())
        }
    }
    
}

