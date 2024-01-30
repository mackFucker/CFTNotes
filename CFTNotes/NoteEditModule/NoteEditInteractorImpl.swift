//
//  NoteEditInteractorImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import Foundation
import Combine

protocol NoteEditInteractor: AnyObject {
    func getBy(uuid: String) async throws -> NoteObjModel? 
    func set(note: NoteObjModel, newNoteText: String)
}

final class NoteEditInteractorImpl: NoteEditInteractor {
    private let dbService = SwiftDataService.shared
//    private var cancellable: AnyCancellable = .init {}

    func getBy(uuid: String) async throws -> NoteObjModel? {
        try await dbService.getBy(uuid: uuid)
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
//        cancellable = Timer.publish(every: 5, on: .main, in: .default)
//            .autoconnect()
//            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
//            .sink { _ in
                self.dbService.set(note: note,
                              newNoteText: newNoteText)
//            }
    }
}
