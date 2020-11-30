//
//  SceneDelegate.swift
//  TimeTable
//
//  Created by ar_ko on 29/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    //var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       guard let _ = (scene as? UIWindowScene) else { return }
        /*let window = UIWindow(windowScene: scene)
        self.window = window
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()*/
    }
}
