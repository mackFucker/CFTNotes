//
//  NotesPresenterImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import Foundation

protocol NotesPresenter: AnyObject {
    func viewDidLoadEvent()
    func viewWillAppearEvent()
    func notesChanges()
    func getNotesViewModels()
}

final class NotesPresenterImpl: NotesPresenter {
    
    private weak var view: NotesViewController?
    
    init(view: NotesViewController) {
        self.view = view
    }
    
    func viewDidLoadEvent() {
                    
    }
    
    func viewWillAppearEvent() {
        view?.reloadTableView()
    }
    
    func notesChanges() {
        view?.reloadTableView()
    }
    
    func getNotesViewModels() {
        
    }
}
