//
//  SettingsCoordinator.swift
//  TimeTable
//
//  Created by ar_ko on 05.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let settingsViewController = SettingsViewController.instantiate()
        let settingsViewModel = SettingsViewModel(coreDataManager: CoreDataManager())
        settingsViewController.viewModel = settingsViewModel
        settingsViewModel.coordinator = self
        
        navigationController.setViewControllers([settingsViewController], animated: false)
        
    }
    
    func childDidFinish(_ childCoodinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoodinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func openProfile() {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.parentCoordinator = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    
}
