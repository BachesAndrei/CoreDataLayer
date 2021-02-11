//
//  ViewController.swift
//  CoreData Layer
//
//  Created by Andrei Baches on 11/01/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let userService = UserService(coreDataStack: CoreDataStack.sharedInstance)
        
        let laptopDevice = Device(name: "test laptop", type: .laptop)
        let phoneDevice = Device(name: "test phone", type: .phone)
        
        let phoneUser = User(id: UUID(), name: "phone user", favoriteDevice: phoneDevice, devices: [laptopDevice, phoneDevice])
        let laptopUser = User(id: UUID(), name: "laptop user", favoriteDevice: laptopDevice, devices: [laptopDevice, phoneDevice])
        let user = User(id: UUID(), name: "no device user", favoriteDevice: nil, devices: [])
        
        
//        print(userService.getUsers())
//
//        userService.clear() {_ in
//            print(userService.getUsers())
//        }
//
//        DispatchQueue.main.async {
//            userService.saveUser(user: phoneUser) { _ in
//                print(userService.getUsers())
//            }
//        }

//        print(userService.getUsers())
        
//        userService.saveUsers(users: [phoneUser, laptopUser]) { _ in
//            print(userService.getUsers())
//        }
    }


}

