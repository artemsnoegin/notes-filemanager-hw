//
//  Note.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import Foundation

struct Note: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var body: String
    var date: Date
    
    init(id: UUID = UUID(), title: String = "", body: String = "", date: Date = .now) {
        
        self.id = id
        self.title = title
        self.body = body
        self.date = date
    }
}
