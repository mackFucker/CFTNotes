//
//  SyntaxHighlightTextStorage.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.

import UIKit

final class SyntaxHighlightTextStorage: NSTextStorage {
    private var backingStore = NSMutableAttributedString()
    
    override init() {
        super.init()
        // прочитать все атрибуты и применить к тексту
        // createHighlightPatterns()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int,
                             effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return backingStore.attributes(at: location,
                                       effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange,
                                    with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range,
                                       with: str)
        edited(.editedCharacters, range: range,
               changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?,
                                range: NSRange) {
        
        beginEditing()
        backingStore.setAttributes(attrs,
                                   range: range)
        edited(.editedAttributes, range: range,
               changeInLength: 0)
        endEditing()
    }
    
    func addImage(_ pathAtImage: URL,
                  at position: NSRange) {
        let imageAttachment = NSTextAttachmentCustom(imageAtPath: pathAtImage)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let descriptorWithTrait = fontDescriptor.withSymbolicTraits(.classClarendonSerifs)
        let font = UIFont(descriptor: descriptorWithTrait!, size: 0)
        
        let attributedString = NSMutableAttributedString(attributedString: imageString)
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: NSRange(location: 0,
                                                     length: attributedString.length))
        
        if position.length == 0 {
            self.insert(attributedString,
                        at: position.location)
        } else {
            deleteCharacters(in: position)
            self.insert(attributedString,
                        at: position.location)
        }
    }
    
    func applyStylesToRange(searchRange: NSRange,
                            style: Style) {
        switch style {
        case .bold:
            let attributes = createAttributesForFontStyle(.body,
                                                          withTrait: .traitBold)
            addAttributes(attributes, range: searchRange)
            
        case .italic:
            let attributes = createAttributesForFontStyle(.body,
                                                          withTrait: .traitItalic)
            addAttributes(attributes, range: searchRange)
            
        case .strike:
            let attributes =  [NSAttributedString.Key.strikethroughStyle: 1]
            addAttributes(attributes, range: searchRange)
            
        case .importantRed:
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
            addAttributes(attributes, range: searchRange)
        }
    }
    
    private func createAttributesForFontStyle(_ style: UIFont.TextStyle,
                                              withTrait trait: UIFontDescriptor.SymbolicTraits) -> [NSAttributedString.Key: Any] {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let descriptorWithTrait = fontDescriptor.withSymbolicTraits(trait)
        let font = UIFont(descriptor: descriptorWithTrait!, size: 0)
        return [.font: font]
    }
}

extension NSAttributedString {

    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(attributedString: .init(data: data,
                                              options: [.documentType: documentType,
                                                        .characterEncoding: encoding.rawValue],
                                              documentAttributes: nil))
    }

    func data(_ documentType: DocumentType) -> Data {
        try! data(from: .init(location: 0, length: length),
                  documentAttributes: [.documentType: documentType])
    }

    var html: Data { data(.html)  }
}
