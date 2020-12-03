//
//  Coordinator.swift
//  TimeTable
//
//  Created by ar_ko on 03.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func start()
    
    func childDidFinish(_ childCoodinator: Coordinator)
}
