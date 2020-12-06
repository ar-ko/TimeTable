//
//  ProfileCoordinator.swift
//  TimeTable
//
//  Created by ar_ko on 05.12.2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewController = ProfileViewController.instantiate()
        let profileViewModel = ProfileViewModel(coreDataManager: CoreDataManager())
        profileViewModel.coordinator = self
        profileViewController.viewModel = profileViewModel
        
        //navigationController.present(profileViewController, animated: true, completion: nil)
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func childDidFinish(_ childCoodinator: Coordinator) {
        
    }
    
    func didFinishProfile() {
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        print("ProfileCoordinator deinit")
    }
    
}
