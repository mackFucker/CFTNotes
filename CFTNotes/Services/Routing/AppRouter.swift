//
//  AppRouter.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import UIKit

final class AppRouter {
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let viewController = NotesViewControllerImpl()
        let presenter = NotesPresenterImpl(view: viewController,
                                           interactor: NotesInteractorImpl())
        viewController.presenter = presenter
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.overrideUserInterfaceStyle = .light
        window?.rootViewController = navController
        navController.navigationBar.prefersLargeTitles = true

        window?.makeKeyAndVisible()
    }
}
