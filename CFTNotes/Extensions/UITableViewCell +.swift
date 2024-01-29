//
//  UITableViewCell +.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 29.01.2024.
//

import UIKit

protocol ReuseIdentifiable: UIView {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable { }
extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension UITableView {
    func register<T: UITableViewCell>(_ : T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(with identifier: String,
                                                 for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error dequeuing cell with identifier: " + identifier)
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath,
                                                 cellType: T.Type = T.self) -> T {
        let dequeueCell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath)
        guard let cell = dequeueCell as? T else {
            fatalError("Error dequeuing cell with identifier: " + cellType.reuseIdentifier)
        }
        return cell
    }
}
