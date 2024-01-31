//
//  MainRouter.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import UIKit

protocol MainRouterProtocol {
    func noteEditShow(navConroller: UINavigationController?,
                      uuid: String)
}

final class MainRouter: MainRouterProtocol {
    
    func noteEditShow(navConroller: UINavigationController?,
                      uuid: String) {
        let interactor = NoteEditInteractorImpl()
        
        let textStorage = SyntaxHighlightTextStorage()
        let editViewController = NoteEditViewContrellerImpl(uuid: uuid,
                                                            textStorage: textStorage,
                                                            imagePickerManager: ImagePickerManager())
        let presenter = NoteEditPresenterImpl(interactor: interactor,
                                              view: editViewController)
        editViewController.presenter = presenter
        
        navConroller?.pushViewController(editViewController, animated: true)
    }
}
