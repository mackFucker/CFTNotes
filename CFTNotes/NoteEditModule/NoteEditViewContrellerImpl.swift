//
//  NoteEditViewContreller.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 27.01.2024.
//

import UIKit
import PhotosUI

protocol NoteEditViewContreller: AnyObject {
    func showAlert(error: String)
}

final class NoteEditViewContrellerImpl: UIViewController {
    private let textStorage: SyntaxHighlightTextStorage
    private let imagePickerManager: ImagePickerManager
    var presenter: NoteEditPresenter!
    
    private var textView: UITextView!
    private var stylesButtonStack: UIStackView!
    private var bottomConstraint: NSLayoutConstraint!
    
    private var uuid: String
    private var data: NoteObjModel?
    private var lastText = ""
    
    init(uuid: String!,
         textStorage: SyntaxHighlightTextStorage,
         imagePickerManager: ImagePickerManager) {
        
        self.uuid = uuid
        self.textStorage = textStorage
        self.imagePickerManager = imagePickerManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            data = await presenter.getBy(uuid: uuid)
            setData(data!)
        }
        
        createTextView()
        createStylesButtons()
        
        addNotification()
        setupUI()
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
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = -keyboardSize.height - 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
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
    
    private func setData(_ data: NoteObjModel) {
        let attr = try! NSAttributedString(data: data.textData,
                                           documentType: .html)
        
        // FIXME:
//        let html = String(data: data.textData, encoding: .utf8) ?? ""
//        print(html)
        // FIXME:
        textStorage.append(attr)
    }
    
    private func createTextView() {
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
        textView.font = UIFont(name: "Times New Roman",
                               size: 17)
        textView.textColor = .label
        textView.delegate = self
        textView.backgroundColor = .white
        view.addSubview(textView)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint.activate([
            stylesButtonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stylesButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bottomConstraint
        ])
    }
    
    private func createStylesButtons() {
        var views: [UIButton] = Style.allCases.map { UIStyleButton(style: $0)}
        views
            .forEach {$0.addTarget(self,
                                   action: #selector(applyStyle),
                                   for: .touchUpInside)}
        views.append(addImageButton)
        
        stylesButtonStack = UIStackView(arrangedSubviews: views)
        stylesButtonStack.translatesAutoresizingMaskIntoConstraints = false
        stylesButtonStack.axis = .horizontal
        stylesButtonStack.distribution = .equalSpacing
        stylesButtonStack.alignment = .center
        stylesButtonStack.backgroundColor = .systemGray3
        stylesButtonStack.layer.cornerRadius = 10
        bottomConstraint = stylesButtonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                     constant: -20)
        view.addSubview(stylesButtonStack)
    }
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.badge.plus"),
                        for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(addImage),
                         for: .touchUpInside)
        return button
    }()
    
    @objc
    private func addImage() {
        self.imagePickerManager.pickImage(vc: self) { image in
            Task.detached { @MainActor in
                self.textStorage.addImage(image,
                                          at: self.textView.selectedRange)
            }
        }
    }
    
    @objc
    private func applyStyle(_ sender: UIStyleButton) {
        textStorage.applyStylesToRange(searchRange: textView.selectedRange,
                                       style: sender.style)
    }
}

extension NoteEditViewContrellerImpl: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if lastText.isEmpty {
            lastText = textView.text
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(setDataInPresenter),
                                               object: lastText)
        lastText = textView.text
        
        self.perform(#selector(setDataInPresenter),
                     with: textView.text,
                     afterDelay: 0.5)
    }
    
    @objc
    private func setDataInPresenter() {
        let dataToSet = textView.attributedText?.html
        presenter.set(note: self.data!,
                      newNoteText: dataToSet ?? Data())
    }
}

extension NoteEditViewContrellerImpl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NoteEditViewContrellerImpl: NoteEditViewContreller {
    func showAlert(error: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        Task.detached { @MainActor in
            self.present(alert, animated: true, completion: nil)
        }
    }
}
