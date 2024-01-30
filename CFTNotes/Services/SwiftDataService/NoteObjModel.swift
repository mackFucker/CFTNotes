//
//  NoteObjModel.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 29.01.2024.
//

import Foundation
import SwiftData

@Model
final class NoteObjModel {
    @Attribute(.unique) var id: String
    var text: String
    var time: Double
    
    init(id: String,
         text: String,
         time: Double) {
        
        self.id = id
        self.text = text
        self.time = time
    }
}
