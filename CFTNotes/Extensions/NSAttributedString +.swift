//
//  NSAttributedString +.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 01.02.2024.
//

import Foundation

extension NSAttributedString {
    func toNSData() -> NSData? {
        let options : [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]

        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range,
                                   documentAttributes: options) else {
            return nil
        }

        return NSData(data: data)
    }
}

extension NSAttributedString {
    convenience init?(base64EndodedImageString encodedImageString: String,
                      fontSize: CGFloat = 17) {
        let html = """
        <!DOCTYPE html>
        <html>
          <body>
            <img src="data:image/png;base64,\(encodedImageString)">
          </body>
        </html>
        """
        let modifiedHtml = html.replacingOccurrences(of: "<body>",
                                                     with: "<body style='font-size: \(fontSize)px;'>")
        let data = Data(modifiedHtml.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            try self.init(data: data,
                          options: options,
                          documentAttributes: nil)
        } catch {
            print("Error initializing NSAttributedString: \(error)")
            return nil
        }
    }
}

