//
//  NoteViewController.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import UIKit

class NoteViewController: UIViewController {
    
    var completion: ((Note) -> Void)?
    
    private var note: Note
    
    private let dateLabel = UILabel()
    
    private let placeholder = ". . ."
    private var placeholderIsOn = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleTextView = UITextView()
    private let bodyTextView = UITextView()
    
    init(note: Note = Note()) {
        
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupUI()
        
        addTapGesture()
        subscribeNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if titleTextView.text.isEmpty && bodyTextView.text.isEmpty {
            
            titleTextView.becomeFirstResponder()
        }
    }
    
    private func setupScrollView() {
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector (saveTapped))
        
        dateLabel.text = note.date.formatted()
        dateLabel.textAlignment = .center
        dateLabel.font = .preferredFont(forTextStyle: .headline)
        dateLabel.textColor = .secondaryLabel
        
        titleTextView.text = note.title
        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        
        titleTextView.delegate = self
        
        bodyTextView.text = note.body
        bodyTextView.font = .preferredFont(forTextStyle: .title3)
        bodyTextView.isScrollEnabled = false
        
        bodyTextView.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, titleTextView, bodyTextView])
        stack.axis = .vertical
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        
        titleTextView.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        
        completion?(note)
    }
    
    private func addTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        
        guard !titleTextView.isFindInteractionEnabled && !bodyTextView.isFirstResponder else { return }
            
        
        if bodyTextView.text.isEmpty {
            
            titleTextView.becomeFirstResponder()
        } else {
            
            bodyTextView.becomeFirstResponder()
        }
    }
    
    private func subscribeNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        scrollView.contentInset.bottom = keyboardFrame.height
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        scrollView.contentInset.bottom = 0
        view.layoutIfNeeded()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension NoteViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        guard textView == titleTextView else { return true }
            
        if placeholderIsOn {
            
            textView.text = ""
            textView.textColor = .label
            placeholderIsOn = false
        }
        
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        guard textView == titleTextView else { return true }
        
        if textView.text.isEmpty {
            
            textView.text = placeholder
            note.title = placeholder
            textView.textColor = .secondaryLabel
            placeholderIsOn = true
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView == titleTextView {
            
            note.title = textView.text
        }
        
        if textView == bodyTextView {
            
            note.body = textView.text
        }
        
        note.date = .now
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if textView == titleTextView {
            
            if text == "\n" && bodyTextView.text.isEmpty {
                
                bodyTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                
                return false
            }
            else if text == "\n" && bodyTextView.hasText {
                
                bodyTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                bodyTextView.text.insert("\n", at: bodyTextView.text.startIndex)
                bodyTextView.selectedRange = NSRange(location: 0, length: 0)
                
                return false
            }
        }
        
        if textView == bodyTextView {
            
            if text == "" && bodyTextView.selectedRange == NSRange(location: 0, length: 0) {
                
                titleTextView.becomeFirstResponder()
                textView.resignFirstResponder()
                
                return false
            }
        }
        
        return true
    }
}
