//
//  Note.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import Foundation

struct Note {
    
    var title: String
    var body: String

    var date: Date
    
    init(title: String = "", body: String = "", date: Date = .now) {
        self.title = title
        self.body = body
        self.date = date
    }
}
