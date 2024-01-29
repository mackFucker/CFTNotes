//
//  SwiftDataService.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 29.01.2024.
//

import Foundation
import SwiftData

final class SwiftDataService {
    static var shared = SwiftDataService()
    var container: ModelContainer?
    var context: ModelContext?
//    var changed: Bool = false
    
    init() {
        do {
            container = try ModelContainer(for: NoteObjModel.self)
            if let container {
                context = ModelContext(container)
//                container.deleteAllData()
//                changed = context!.hasChanges
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func append(title: String?) {
        guard let title else { return }
        if let context {
            let noteToBeappended = NoteObjModel(id: UUID().uuidString,
                                                title: title,
                                                text: "",
                                                time: Date().timeIntervalSince1970)
            context.insert(noteToBeappended)
        }
    }
    
    func get() async throws -> [NoteObjModel] {
        let descriptor = FetchDescriptor<NoteObjModel>(sortBy: [SortDescriptor<NoteObjModel>(\.time)])
        guard let context else {
            throw NSError(domain: "Error fetching tasks",
                          code: 100,
                          userInfo: nil)
        }
        do {
            let data = try context.fetch(descriptor)
            return data
        } catch {
            throw error
        }
    }
    
    func getBy(id: Int) async throws -> NoteObjModel  {
        return NoteObjModel(id: "", title: "", text: "", time: 12)
    }
    
    func set(note: NoteObjModel,
             newNoteText: String) {
        let noteToBeUpdated = note
        noteToBeUpdated.text = newNoteText
    }
    
    func deleteBy(note: NoteObjModel) {
        let noteToBeDeleted = note
        if let context {
            context.delete(noteToBeDeleted)
        }
    }
}
