//
//  MainRouter.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import UIKit

public protocol MainRouterProtocol {
    func noteEditShow(navConroller: UINavigationController?,
                      uuid: String)
 }

final class MainRouter: MainRouterProtocol {
        
    func noteEditShow(navConroller: UINavigationController?,
                      uuid: String) {
        let editViewController = NoteEditViewContrellerImpl(uuid: uuid)
        navConroller?.pushViewController(editViewController, animated: true)
    }
}
