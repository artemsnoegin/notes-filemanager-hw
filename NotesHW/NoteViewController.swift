//
//  NoteViewController.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    // TODO: add scroll, add date, change return and delete behavior, hide keyboard on scroll, title first responder
    // TODO: add save on deinit?
    
    private var note: Note
    private let titleTextView = UITextView()
    private let bodyTextView = UITextView()
    
    var completion: ((Note) -> Void)?
    
    init(note: Note = Note(title: "", body: "", date: .now)) {
        
        self.note = note
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneEditing))
        navigationItem.rightBarButtonItem?.isHidden = true
        
        titleTextView.text = note.title
        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        
        titleTextView.delegate = self
        
        bodyTextView.text = note.body
        bodyTextView.font = .preferredFont(forTextStyle: .title3)
        bodyTextView.isScrollEnabled = false
        
        bodyTextView.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {

        navigationItem.rightBarButtonItem?.isHidden = false
        
        if textView == titleTextView {
            
            note.title = titleTextView.text
        }
        
        if textView == bodyTextView {
            
            note.body = textView.text
            
        }
        
        note.date = .now
    }
    
    @objc private func doneEditing() {
        
        titleTextView.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        
        navigationItem.rightBarButtonItem?.isHidden = true
        completion?(note)
    }
}
