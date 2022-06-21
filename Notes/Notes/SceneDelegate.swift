//
//  SceneDelegate.swift
//  Notes
//
//  Created by Nikita Yakovlev on 27.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let navigationController = UINavigationController()
            let viewController = ListNotesAssembly.build()
            navigationController.viewControllers = [viewController]
            window.rootViewController = navigationController
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
}
