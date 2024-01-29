//
//  NotesInteractorImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import Foundation

protocol NotesInteractor: AnyObject {
    func append(title: String?)
    
    func get() async throws -> [NoteObjModel]
    func getBy(id: Int) async throws -> NoteObjModel
    func set(note: NoteObjModel, newNoteText: String)
    func deleteBy(note: NoteObjModel)
}

final class NotesInteractorImpl: NotesInteractor {
    let dbService = SwiftDataService.shared
    
    func append(title: String?) {
        dbService.append(title: title)
    }
    
    func get() async throws -> [NoteObjModel] {
        try await dbService.get()
    }
    
    func getBy(id: Int) async throws -> NoteObjModel {
        try await dbService.getBy(id: id)
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
        dbService.set(note: note,
                      newNoteText: "AAAAAA")
    }
    
    func deleteBy(note: NoteObjModel) {
        dbService.deleteBy(note: note)
    }
}
