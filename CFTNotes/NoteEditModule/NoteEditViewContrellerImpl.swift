//
//  NoteEditViewContreller.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.
//

import UIKit

final class NoteEditViewContrellerImpl: UIViewController {
    private var textStorage = SyntaxHighlightTextStorage()
    private let screenBounds = UIScreen.main.bounds
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
        textView.delegate = self
        view.addSubview(textView)
        view.addSubview(stylesButtonStack)
        
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
    
    private lazy var stylesButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [boldButton,
                                                 italicButton,
                                                 strikeButton,
                                                 importantButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
//        stack.spacing = 10
        stack.backgroundColor = .systemGray3
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            stylesButtonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stylesButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stylesButtonStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private lazy var boldButton: UIStyleButton = {
        let button = UIStyleButton(style: .bold)
        button.addTarget(self, action: #selector(applyStyle), for: .touchUpInside)
        return button
    }()
    
    private lazy var italicButton: UIStyleButton = {
        let button = UIStyleButton(style: .italic)
        button.addTarget(self, action: #selector(applyStyle), for: .touchUpInside)
        return button
    }()
    
    private lazy var strikeButton: UIStyleButton = {
        let button = UIStyleButton(style: .strike)
        button.addTarget(self, action: #selector(applyStyle), for: .touchUpInside)
        return button
    }()
    
    private lazy var importantButton: UIStyleButton = {
        let button = UIStyleButton(style: .importantRed)
        button.addTarget(self, action: #selector(applyStyle), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func applyStyle(_ sender: UIStyleButton) {
        textStorage.applyStylesToRange(searchRange: textView.selectedRange,
                                       style: sender.style)
//        print(textStorage.attributedSubstring(from: NSRange(0..<note.count)))
    }
}

final class UIStyleButton: UIButton {
    let style: Style
    
    init(style: Style) {
        self.style = style
        super.init(frame: .infinite)
        switch style {
        case .bold:
            self.setBackgroundImage(UIImage(systemName: "bold"),
                                    for: .normal)
        case .italic:
            self.setBackgroundImage(UIImage(systemName: "italic"),
                                    for: .normal)
        case .strike:
            self.setBackgroundImage(UIImage(systemName: "strikethrough"),
                                    for: .normal)
        case .importantRed:
            self.setBackgroundImage(UIImage(systemName: "exclamationmark"),
                                    for: .normal)
        }
        self.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteEditViewContrellerImpl: UITextViewDelegate {
  
}

extension NoteEditViewContrellerImpl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
