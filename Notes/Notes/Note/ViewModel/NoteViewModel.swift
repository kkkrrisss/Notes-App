//
//  NoteViewModel.swift
//  Notes
//
//  Created by Кристина Олейник on 14.08.2025.
//

import Foundation

protocol NoteViewModelProtocol {
    var text: String { get }
    var noteCategory: Category { get set }
    var isNewNote: Bool { get }
    
    func save(text: String, category: Category?)
    func delete()
    func hasChanged(text: String) -> Bool
}

final class NoteViewModel: NoteViewModelProtocol {
    let note: Note?
    
    var noteCategory: Category
    var oldNoteCategory: Category
    var isNewNote: Bool
    
    var text: String {
        let text = (note?.title ?? "") + "\n\n" + (note?.description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
        
    init(note: Note?, isNewNote: Bool = false) {
        self.note = note
        self.noteCategory = note?.category ?? .personal
        self.oldNoteCategory = noteCategory
        self.isNewNote = isNewNote
    }
    
    //MARK: - Methods
    
    func save(text: String, category: Category?) {
        let date = note?.date ?? Date()
        let (title, description) = createTitleAndDescription(from: text)
        let note = Note(title: title,
                        description: description,
                        date: date,
                        category: category ?? .personal,
                        imageURL: nil )
        NotePersistent.save(note)
    }
    
    func delete() {
        guard let note = note else { return }
        NotePersistent.delete(note)
    }
    
    func hasChanged(text: String) -> Bool {
        let textChanged = self.text != text
        let categoryChanged = noteCategory != oldNoteCategory
        return (textChanged || categoryChanged) && (text != "")
    }
    //MARK: - Private methods
    private func createTitleAndDescription(from text: String) -> (String, String?) {
        var description = text
        
        guard let index = description.firstIndex(where: {
            $0 == "." ||
            $0 == "!" ||
            $0 == "?" ||
            $0 == "\n"})
        else {
            return (text, nil)
        }
        
        let title = String(description[...index])
        description.removeSubrange(...index)
        
        return (title, description)
    }
}
