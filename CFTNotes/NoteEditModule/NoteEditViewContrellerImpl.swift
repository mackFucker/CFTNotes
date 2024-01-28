//
//  NoteEditViewContreller.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.
//

import UIKit
import PhotosUI

final class NoteEditViewContrellerImpl: UIViewController {
    private var textStorage = SyntaxHighlightTextStorage()
    private let screenBounds = UIScreen.main.bounds
    var textView: UITextView!
    
    private let note = """
If you have used Core Data before, you may remember that you have to create a data model (with a file extension .xcdatamodeld) using a data model editor for data persistence. With the release of SwiftData, you no longer need to do that. SwiftData streamlines the whole process with macros, another new Swift feature in iOS 17. Say, for example, you already define a model class for Song as follows:
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomConstraint = stylesButtonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        addNotification()
        setupUI()
        createTextView()        
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = -keyboardSize.height - 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = -20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        let swipeUp = UISwipeGestureRecognizer(target: self,
                                               action: #selector(self.hideKeyboard))
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action:  #selector(self.hideKeyboard))
        
        let hideTouch = UITapGestureRecognizer(target: textView,
                                               action:  #selector(self.hideKeyboard))
        
        hideTouch.delegate = self
        hideTouch.cancelsTouchesInView = false
        
        swipeUp.delegate = self
        swipeDown.delegate = self
        
        swipeUp.direction =  UISwipeGestureRecognizer.Direction.up
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)
        
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
        textView.textColor = .label
        textView.delegate = self
        view.addSubview(textView)
        view.addSubview(stylesButtonStack)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
//    private lazy var textView: UITextView = {
//        let textView = UITextView(frame: view.bounds)
//        textView.font = UIFont.systemFont(ofSize: 20)
//        return textView
//    }()
    
    private lazy var stylesButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [boldButton,
                                                   italicButton,
                                                   strikeButton,
                                                   importantButton,
                                                   addImageButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = .systemGray3
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private var bottomConstraint: NSLayoutConstraint!
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            stylesButtonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stylesButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stylesButtonStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomConstraint
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
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func addImage() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc
    private func applyStyle(_ sender: UIStyleButton) {
        textStorage.applyStylesToRange(searchRange: textView.selectedRange,
                                       style: sender.style)
    }
}

extension NoteEditViewContrellerImpl: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object,
                error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.textStorage.addImage(image,
                                                  at: self.textView.selectedRange)
                    }
                }
            }
        }
       
        dismiss(animated: true)
    }
}

extension NoteEditViewContrellerImpl: UITextViewDelegate {
  
}

extension NoteEditViewContrellerImpl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
