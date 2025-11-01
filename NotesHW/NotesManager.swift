//
//  NotesManager.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import Foundation

class NotesManager {
    
    private var notes = [Note]()
    
    private var mock = [
        Note(
            title: "Hello World!",
            body: "Hello World!",
            date: Date(timeInterval: 0, since: .now)),
        Note(
            title: "Hello User!",
            body: "Hello User!",
            date: Date(timeInterval: 60 * 60, since: .now)),
        Note(
            title: "Hello Developer!",
            body: "Hello Developer!",
            date: Date(timeInterval: 60 * (60 * 24), since: .now))]
    
    func loadMock() -> [Note] { mock }
    
    func load() -> [Note] {
        
        notes
    }
    
    func save(note: Note) {
        
        notes.append(note)
    }
    
    func update(_ note: Note, at index: Int) {
        
        notes[index] = note
    }
    
    func delete(at index: Int) {
        
        notes.remove(at: index)
    }
}
