//
//  NotesTableViewController.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    private var notes = [Note]()
    
    private let notesManger = NotesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = notesManger.load()
        tableView.reloadData()
    }
    
    private func configureNavigationBar() {
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNote))
    }
    
    @objc private func createNewNote() {

        let noteViewController = NoteViewController()
        
        noteViewController.completion = { [weak self] note in
            
            self?.notesManger.save(note: note)
        }
        
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}

extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noteForCell = notes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = noteForCell.title
        contentConfiguration.textProperties.numberOfLines = 1
        
        contentConfiguration.secondaryText = noteForCell.body
        contentConfiguration.secondaryTextProperties.numberOfLines = 2
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNote = notes[indexPath.row]
        
        let noteViewController = NoteViewController(note: selectedNote)
        
        noteViewController.completion = { [weak self] note in
            
            self?.notesManger.update(note, at: indexPath.row)
        }
        
        navigationController?.pushViewController(noteViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        notes.remove(at: indexPath.row)
        notesManger.delete(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
