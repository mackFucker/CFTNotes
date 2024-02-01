//
//  NoteEditPresenter.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 30.01.2024.
//

import Foundation

protocol NoteEditPresenter: AnyObject {
    func getBy(uuid: String) async -> NoteObjModel?
    func set(note: NoteObjModel, newNoteText: Data)
}

final class NoteEditPresenterImpl: NoteEditPresenter {
    private var interactor: NoteEditInteractor
    weak var view: NoteEditViewContreller?
    
    init(interactor: NoteEditInteractor,
         view: NoteEditViewContreller) {
        
        self.interactor = interactor
        self.view = view
    }
    
    func getBy(uuid: String) async -> NoteObjModel? {
        do {
            return try await interactor.getBy(uuid: uuid)
        }
        catch {
            let error = error as! SwiftDataService.Errors
            switch error {
            case .fetchingError:
                view?.showAlert(error: "Fetching error")
            case .notFound:
                view?.showAlert(error: "Not found")
            }
            return NoteObjModel(id: "", text: Data(), time: 00)
        }
    }
    
    func set(note: NoteObjModel, newNoteText: Data) {
        interactor.set(note: note, newNoteText: newNoteText)
    }
}
