//
//  UIStyleButton.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 28.01.2024.
//

import UIKit

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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
