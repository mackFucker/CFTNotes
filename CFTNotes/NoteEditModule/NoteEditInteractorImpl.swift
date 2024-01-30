//
//  NoteEditInteractorImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import Foundation

protocol NoteEditInteractor: AnyObject {
    func getBy(uuid: String) async throws -> NoteObjModel? 
    func set(note: NoteObjModel, newNoteText: String)
}

final class NoteEditInteractorImpl: NoteEditInteractor {
    private let dbService = SwiftDataService.shared

    func getBy(uuid: String) async throws -> NoteObjModel? {
        try await dbService.getBy(uuid: uuid)
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
        
        dbService.set(note: note,
                      newNoteText: newNoteText)
    }
}
