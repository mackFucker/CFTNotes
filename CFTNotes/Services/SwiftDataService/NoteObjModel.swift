//
//  NoteObjModel.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 29.01.2024.
//

import Foundation
import SwiftData

@Model
class NoteObjModel {
    @Attribute(.unique) var id: String
    
    var title: String
    var text: String
    var time: Double
    
    init(id: String,
         title: String,
         text: String,
         time: Double) {
        
        self.id = id
        self.title = title
        self.text = text
        self.time = time
    }
}
