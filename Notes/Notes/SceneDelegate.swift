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
            let viewController = ListViewController()
            navigationController.viewControllers = [viewController]
            window.rootViewController = navigationController
            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            if let firstViewController = navigationController.viewControllers.first as? ListViewController {
                NoteArrayDataProvider.getInstance().saveNotes(firstViewController.arrayNotes)
            }
        }
    }
}
