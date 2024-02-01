//
//  NSData + .swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 01.02.2024.
//

import Foundation

extension NSData {
    func toAttributedString(ignoringTextAttachment: Bool = false) -> NSAttributedString? {
        let data = Data(referencing: self)
        let options : [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        guard let attributedString = try? NSAttributedString(data: data,
                                                            options: options,
                                                            documentAttributes: nil) else {
            return nil
        }

        if ignoringTextAttachment {
            let result = NSMutableAttributedString()
            attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []) { (attributes, range, stop) in
                if attributes[NSAttributedString.Key.attachment] == nil {
                    let subAttributedString = attributedString.attributedSubstring(from: range)
                    result.append(subAttributedString)
                }
            }
            return result
        } else {
            return attributedString
        }
    }
}
