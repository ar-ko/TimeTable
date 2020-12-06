//
//  TimetableCoordinator.swift
//  TimeTable
//
//  Created by ar_ko on 03.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

final class TimetableCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let timetableViewController = TimetableViewController.instantiate()
        timetableViewController.viewModel = TimetableViewModel(coreDataManager: CoreDataManager())
        
        navigationController.setViewControllers([timetableViewController], animated: false)
    }
    
    func childDidFinish(_ childCoodinator: Coordinator) {
        
    }
    
}
