//
//  NotesViewControllerImpl.swift
//  CFTNotes
//
//  Created by Дэвид Кихтенко on 26.01.2024.
//

import UIKit

protocol NotesViewController: AnyObject {
    func reloadTableView()
}

final class NotesViewControllerImpl: UIViewController,
                                     NotesViewController {

    var presenter: NotesPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoadEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppearEvent()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds,
                                    style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NoteCell.self,
                           forCellReuseIdentifier: NoteCell.identifer)
        return tableView
    }()
    
    private func setupUI() {
        self.title = "CFTNotes"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    private func tapOnCell(_ id: Int) {
        //router  action
    }
    
    func reloadTableView() {
        presenter.getNotesViewModels()
    }
}

extension NotesViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifer,
                                                 for: indexPath) as! NoteCell
        return cell
    }
}

extension NotesViewControllerImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}
