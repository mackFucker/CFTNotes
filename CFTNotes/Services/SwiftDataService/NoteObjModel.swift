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
    var textData: Data
    var time: Double
    
    init(id: String,
         text: NSData,
         time: Double) {
        
        self.id = id
        self.textData = text as Data
        self.time = time
    }
}



