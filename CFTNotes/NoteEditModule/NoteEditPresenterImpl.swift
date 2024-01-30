//
//  NoteEditPresenter.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import Foundation

protocol NoteEditPresenter: AnyObject {
    func getBy(uuid: String) async -> NoteObjModel?
    func set(note: NoteObjModel, newNoteText: String)
    
}

final class NoteEditPresenterImpl: NoteEditPresenter {
    private let interactor: NoteEditInteractor = NoteEditInteractorImpl()
    
//    init(interactor: NoteEditInteractor) {
//        self.interactor = interactor
//    }
    func getBy(uuid: String) async -> NoteObjModel? {
        do {
            return try await interactor.getBy(uuid: uuid)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func set(note: NoteObjModel, newNoteText: String) {
        interactor.set(note: note, newNoteText: newNoteText)
    }
}
