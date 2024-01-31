//
//  NotesViewControllerImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import UIKit

protocol NotesViewController: AnyObject {
    func reloadTableView()
    func showAlert(error: String)
}

final class NotesViewControllerImpl: UIViewController,
                                     NotesViewController {
    private let router = MainRouter()
    var presenter: NotesPresenter!
    var data = [NoteObjModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoadEvent()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds,
                                    style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 44
        tableView.register(NoteCell.self)
        return tableView
    }()
    
    private lazy var addNoteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(appendNote),
                         for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"),
                        for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    func showAlert(error: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    private func appendNote() {
        presenter.appendNote()
    }
    
    private func setupUI() {
        self.title = "CFTNotes"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        let barButtonItem = UIBarButtonItem(customView: addNoteButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func tapOnCell(_ uuid: String) {
        router.noteEditShow(navConroller: navigationController,
                            uuid: uuid)
    }
    
    func reloadTableView() {
        Task {
            data = await presenter.get()
            updateTableView(with: data)
        }
    }
    
    @MainActor
    private func updateTableView(with data: [NoteObjModel]) {
        self.data = data
        tableView.reloadData()
    }
    
}

extension NotesViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NoteCell.reuseIdentifier,
                                                 for: indexPath) as NoteCell
        cell.setup(title: data[indexPath.row].text)
        return cell
    }
}

extension NotesViewControllerImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tapOnCell(data[indexPath.row].id)
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.presenter.deleteBy(note: self.data[indexPath.row])
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
