//
//  NotesPresenterImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import Foundation

protocol NotesPresenter: AnyObject {
    func appendNote()
    func get() async -> [NoteObjModel]?
    func getBy(id: Int) async -> NoteObjModel?

    func set(note: NoteObjModel, newNoteText: String)
    func deleteBy(note: NoteObjModel)
    
    func viewDidLoadEvent()
    func viewWillAppearEvent()
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
        interactor.append(title: "1 1 1 1 1 ")
        view?.reloadTableView()
    }
    
    func get() async -> [NoteObjModel]? {
        do {
            return try await interactor.get()
        }
        catch {
            print(error)
            //view.alert
            return nil
        }
//        view?.reloadTableView()
    }
    
    func getBy(id: Int) async -> NoteObjModel? {
        do {
            return try await interactor.getBy(id: id)
        }
        catch {
            print(error)
            //view.alert
            return nil
        }
//        view?.reloadTableView()
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
        interactor.set(note: note, newNoteText: newNoteText)
    }
    
    func deleteBy(note: NoteObjModel) {
        interactor.deleteBy(note: note)
        view?.reloadTableView()
    }
    
    func viewDidLoadEvent() {
        //create publisher in interactor -> dbService
         
    }
    
    func viewWillAppearEvent() {
        view?.reloadTableView()
    }
    
    func notesChanges() {
        view?.reloadTableView()
    }
}
