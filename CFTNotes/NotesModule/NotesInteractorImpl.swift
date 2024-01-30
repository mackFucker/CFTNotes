//
//  NotesInteractorImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import Foundation
import Combine

protocol NotesInteractor: AnyObject {
    func append()
    func get() async throws -> [NoteObjModel]
    func set(note: NoteObjModel, newNoteText: String)
    func deleteBy(note: NoteObjModel)
    func subscribe(presenter: NotesPresenter)
}

final class NotesInteractorImpl: NotesInteractor {
    private let dbService = SwiftDataService.shared
    private var cancellable: Set<AnyCancellable> = .init()
    
    func subscribe(presenter: NotesPresenter) {
        dbService.subscribe()
            .sink(receiveValue: {_ in 
                presenter.notesChanges()
            })
            .store(in: &cancellable)
    }
    
    func append() {
        dbService.append()
    }
    
    func get() async throws -> [NoteObjModel] {
        try await dbService.get()
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
        dbService.set(note: note,
                      newNoteText: newNoteText)
    }
    
    func deleteBy(note: NoteObjModel) {
        dbService.deleteBy(note: note)
    }
}
