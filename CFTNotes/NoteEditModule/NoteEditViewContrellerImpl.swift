//
//  NoteEditViewContreller.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.
//

import UIKit

final class NoteEditViewContrellerImpl: UIViewController {
    private var textStorage = SyntaxHighlightTextStorage()

    private let note = """
Hopefully, this Text Kit tutorial has helped you understand the features of the library you'll no doubt find useful in practically every app that you write. You've implemented dynamic type support, learned to respond to changes in text sizes within your app, used exclusion paths, and dynamically applied styles to text.
1. *bold ddddd*
2. _italic _italic_
3. -strike through-
4. ~script script~.
5. ALL CAPS.
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createTextView()
    }
    
    private func setupUI() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDownAndTouch))
        let hideTouch = UITapGestureRecognizer(target: self, action:  #selector(self.hideKeyboardOnSwipeDownAndTouch))
        
        swipeUp.delegate = self
        hideTouch.delegate = self
        
        swipeUp.direction =  UISwipeGestureRecognizer.Direction.up
        hideTouch.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(hideTouch)
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.backgroundColor = .systemBackground
    }
    
    private func createTextView() {
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let attrString = NSAttributedString(string: note,
                                            attributes: attrs)
        
        textStorage.append(attrString)
        
        let newTextViewRect = view.bounds
        
        let layoutManager = NSLayoutManager()
        
        let containerSize = CGSize(width: newTextViewRect.width,
                                   height: .greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        textView = UITextView(frame: newTextViewRect,
                              textContainer: container)
//        textView.delegate = self
        view.addSubview(textView)
    }
    
    @objc
    func hideKeyboardOnSwipeDownAndTouch() {
        view.endEditing(true)
    }
    
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: view.bounds)
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
}

//extension NoteEditViewContrellerImpl: UITextViewDelegate {
//    
//}

extension NoteEditViewContrellerImpl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
