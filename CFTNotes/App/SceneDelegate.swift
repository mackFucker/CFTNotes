//
//  SceneDelegate.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //FIXME: DI OR ...
        let viewController = NotesViewControllerImpl()
        let presenter = NotesPresenterImpl(view: viewController,
                                           interactor: NotesInteractorImpl())
        viewController.presenter = presenter
//        let viewController = NoteEditViewContrellerImpl()
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
