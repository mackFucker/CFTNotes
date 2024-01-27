//
//  SyntaxHighlightTextStorage.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.
//

import UIKit

final class SyntaxHighlightTextStorage: NSTextStorage {
    private let backingStore = NSMutableAttributedString()
    private var replacements: [String: [NSAttributedString.Key: Any]] = [:]
    
    override init() {
        super.init()
        createHighlightPatterns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var string: String {
        return backingStore.string
    }
    
    override func processEditing() {
        performReplacementsForRange(changedRange: editedRange)
        super.processEditing()
    }
    
    override func attributes(at location: Int,
                             effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return backingStore.attributes(at: location,
                                       effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange,
                                    with str: String) {
        print("replaceCharactersInRange:\(range) withString:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with:str)
        edited(.editedCharacters, range: range,
               changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?,
                                range: NSRange) {
        print("setAttributes:\(String(describing: attrs)) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    func applyStylesToRange(searchRange: NSRange) {
        let normalAttrs =
        [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        addAttributes(normalAttrs, range: searchRange)
        
        for (pattern, attributes) in replacements {
            do {
                let regex = try NSRegularExpression(pattern: pattern)
                regex.enumerateMatches(in: backingStore.string, range: searchRange) {
                    match, flags, stop in
                    if let matchRange = match?.range(at: 1) {
                        print("Matched pattern: \(pattern)")
                        addAttributes(attributes, range: matchRange)
                        
                        let maxRange = matchRange.location + matchRange.length
                        if maxRange + 1 < length {
                            addAttributes(normalAttrs, range: NSMakeRange(maxRange, 1))
                        }
                    }
                }
            }
            catch {
                print("An error occurred attempting to locate pattern: " +
                      "\(error.localizedDescription)")
            }
        }
    }
    
    private func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange,
                                         NSString(string: backingStore.string)
            .lineRange(for: NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange,
                                     NSString(string: backingStore.string)
            .lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(searchRange: extendedRange)
    }
    
    private func createAttributesForFontStyle(_ style: UIFont.TextStyle,
                                              withTrait trait: UIFontDescriptor.SymbolicTraits) -> [NSAttributedString.Key: Any] {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let descriptorWithTrait = fontDescriptor.withSymbolicTraits(trait)
        let font = UIFont(descriptor: descriptorWithTrait!, size: 0)
        return [.font: font]
    }
    
    private func createHighlightPatterns() {
        let scriptFontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Zapfino"])
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let bodyFontSize = bodyFontDescriptor.fontAttributes[.size] as! NSNumber
        let scriptFont = UIFont(descriptor: scriptFontDescriptor,
                                size: CGFloat(bodyFontSize.floatValue))
        
        let boldAttributes = createAttributesForFontStyle(.body,
                                                          withTrait:.traitBold)
        let italicAttributes = createAttributesForFontStyle(.body,
                                                            withTrait:.traitItalic)
        let strikeThroughAttributes =  [NSAttributedString.Key.strikethroughStyle: 1]
        
        let scriptAttributes = [NSAttributedString.Key.font: scriptFont]
        let redTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        
        replacements = [
           "(\\*\\w+(\\s\\w+)*\\*)": boldAttributes,
           "(_\\w+(\\s\\w+)*_)": italicAttributes,
           "([0-9]+\\.)\\s": boldAttributes,
           "(-\\w+(\\s\\w+)*-)": strikeThroughAttributes,
           "(~\\w+(\\s\\w+)*~)": scriptAttributes,
           "\\b([A-Z]{2,})\\b": redTextAttributes
         ]
    }
}

