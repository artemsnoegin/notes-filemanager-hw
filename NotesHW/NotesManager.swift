//
//  NotesManager.swift
//  NotesHW
//
//  Created by Артём Сноегин on 31.10.2025.
//

import Foundation

class NotesManager {
    
    private var notes = [Note]()
    
    private var fileURL: URL {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("note.txt")
    }
    
    private var greeting = [
        Note(
            title: "Hello!",
            body: "Hello!",
            date: Date(timeInterval: 0, since: .now)),
        ]
    
    func loadGreeting() -> [Note] { greeting }
    
    func loadFromFile() -> [Note] {
        
        if let data = FileManager.default.contents(atPath: fileURL.path()) {
            
            encode(data) { result in
                
                switch result {
                    
                case .success(let notes):
                    self.notes = notes
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        return notes
    }
    
    func saveToFile(_ notes: [Note]) {
        
        decode(notes) { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    try data.write(to: fileURL)
                }
                catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func decode(_ notes: [Note], completion: (Result<Data, Error>) -> Void) {
        
        do {
            let data = try JSONEncoder().encode(notes)
            completion(.success(data))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    private func encode(_ data: Data, completion: (Result<[Note], Error>) -> Void) {
        
        do {
            let note = try JSONDecoder().decode([Note].self, from: data)
            completion(.success(note))
        }
        catch {
            completion(.failure(error))
        }
    }
}
