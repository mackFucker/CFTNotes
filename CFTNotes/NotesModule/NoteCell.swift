//
//  NoteCell.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import UIKit

final class NoteCell: UITableViewCell {
    
    static let identifer = "NoteCell"
    
    private var cellID: Int!
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
 
        contentView.addSubview(title)

        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 20)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setup(title: Data) {
        let html = String(data: title,
                          encoding: .utf8) ?? ""
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let font = UIFont.systemFont(ofSize: 17)
            mutableAttributedString.addAttribute(NSAttributedString.Key.font,
                                          value: font,
                                          range: NSRange(location: 0,
                                                         length: attributedString.length))
            self.title.attributedText = mutableAttributedString
        }
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 30),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -30)
        ])
        super.updateConstraints()
    }
}
