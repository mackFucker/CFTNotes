//
//  NotesPresenterImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import Foundation

protocol NotesPresenter: AnyObject {
    func appendNote()
    func get() async -> [NoteObjModel]

    func deleteBy(note: NoteObjModel)
    
    func viewDidLoadEvent()
    func notesChanges()
}

final class NotesPresenterImpl: NotesPresenter {
    private weak var view: NotesViewController?
    private let interactor: NotesInteractor
    
    init(view: NotesViewController,
         interactor: NotesInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func appendNote() {
        interactor.append()
    }

    func get() async -> [NoteObjModel] {
        do {
            return try await interactor.get()
        }
        catch {
            let error = error as! SwiftDataService.Errors
            switch error {
            case .fetchingError:
                view?.showAlert(error: "Fetching error")
            case .notFound:
                view?.showAlert(error: "Not found")
            }
            return [NoteObjModel]()
        }
    }
    
    func deleteBy(note: NoteObjModel) {
        interactor.deleteBy(note: note)
    }
    
    func viewDidLoadEvent() {
        interactor.subscribe(presenter: self)
    }
    
    func notesChanges() {
        view?.reloadTableView()
    }
}
