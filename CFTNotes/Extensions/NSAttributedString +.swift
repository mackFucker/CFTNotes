//
//  NSAttributedString +.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 01.02.2024.
//

import Foundation

extension NSAttributedString {
    convenience init(data: Data,
                     documentType: DocumentType,
                     encoding: String.Encoding = .utf8) throws {
        try self.init(attributedString: .init(data: data,
                                              options: [.documentType: documentType,
                                                        .characterEncoding: encoding.rawValue],
                                              documentAttributes: nil))
    }
    
    func data(_ documentType: DocumentType) -> Data {
        
        return try! data(from: .init(location: 0,
                                     length: length),
                         documentAttributes: [.documentType: documentType])
    }
    
    var html: Data { data(.html) }
}
