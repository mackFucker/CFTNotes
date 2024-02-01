//
//  SwiftDataService.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 29.01.2024.
//

import Foundation
import SwiftData
import Combine

final class SwiftDataService {
    static var shared = SwiftDataService()
    var container: ModelContainer?
    var context: ModelContext?
    private var notesPublisher: CurrentValueSubject<TypeOfChanges, Never> = CurrentValueSubject(
        .appStart
    )
    
    init() {
        do {
            container = try ModelContainer(for: NoteObjModel.self)
            if let container {
                context = ModelContext(container)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func subscribe() -> AnyPublisher<TypeOfChanges, Never> {
        return notesPublisher.eraseToAnyPublisher()
    }
    
    func append() {
        if let context {
            let noteToBeappended = NoteObjModel(id: UUID().uuidString,
                                                text: NSData(),
                                                time: Date().timeIntervalSince1970)
            context.insert(noteToBeappended)
            notesPublisher.send(.defaultChanges)
        }
    }
    
    func get() async throws -> [NoteObjModel] {
        let descriptor = FetchDescriptor<NoteObjModel>(sortBy: [SortDescriptor<NoteObjModel>(\.time)])
        guard let context else {
            throw Errors.fetchingError
        }
        do {
            let data = try context.fetch(descriptor)
            return data
        } catch {
            throw Errors.fetchingError
        }
    }
    
    func getBy(uuid: String) async throws -> NoteObjModel? {
        let descriptor = FetchDescriptor<NoteObjModel>(sortBy: [SortDescriptor<NoteObjModel>(\.time)])
        guard let context else {
            throw Errors.fetchingError
        }
        do {
            let data = try context.fetch(descriptor)
            if let result = data.first(where: { $0.id == uuid }) {
                return result
            } else {
                throw Errors.notFound
            }
        } catch {
            throw Errors.fetchingError
        }
    }
    
    func set(note: NoteObjModel,
             newNoteText: NSData) {
        let noteToBeUpdated = note
        noteToBeUpdated.textData = newNoteText as Data
    }
    
    func deleteBy(note: NoteObjModel) {
        let noteToBeDeleted = note
        if let context {
            context.delete(noteToBeDeleted)
        }
        notesPublisher.send(.defaultChanges)
    }
}

extension SwiftDataService {
    enum Errors: Error {
        case fetchingError
        case notFound
    }
}

extension SwiftDataService {
    enum TypeOfChanges {
        case appStart
        case defaultChanges
    }
}
