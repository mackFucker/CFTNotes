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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
