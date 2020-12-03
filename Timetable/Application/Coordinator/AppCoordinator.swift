//
//  AppCoordinator.swift
//  TimeTable
//
//  Created by ar_ko on 03.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        
        let timetableCoordinator = TimetableCoordinator(navigationController: navigationController)
        childCoordinators.append(timetableCoordinator)
        
        timetableCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(_ childCoodinator: Coordinator) {
        
    }
}
