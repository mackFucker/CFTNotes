//
//  UITableView +.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 31.01.2024.
//

import UIKit

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections),
                       with: animation)
    }
}
