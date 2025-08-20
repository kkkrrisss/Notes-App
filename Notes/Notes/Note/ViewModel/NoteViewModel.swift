//
//  NoteViewModel.swift
//  Notes
//
//  Created by Кристина Олейник on 14.08.2025.
//

import Foundation
import UIKit

protocol NoteViewModelProtocol {
    var text: String { get }
    var noteCategory: Category { get set }
    var isNewNote: Bool { get }
    var image: UIImage? { get }
    
    func save(text: String, image: UIImage?, imageName: String?)
    func delete()
    func hasChanged(text: String, imageName: String?) -> Bool
}

final class NoteViewModel: NoteViewModelProtocol {
    let note: Note?
    
    private var oldNoteCategory: Category
    var noteCategory: Category
    var isNewNote: Bool
    
    var text: String {
        let text = (note?.title ?? "") + "\n\n" + (note?.description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
        
    var image: UIImage? {
        guard let url = note?.imageURL else { return nil }
        return FileManagerPersistent.read(from: url)
    }
    
    init(note: Note?, isNewNote: Bool = false) {
        self.note = note
        self.noteCategory = note?.category ?? .personal
        self.oldNoteCategory = noteCategory
        self.isNewNote = isNewNote
    }
    
    //MARK: - Methods
    
    func save(text: String,
              image: UIImage?,
              imageName: String?) {
        var url: URL? = note?.imageURL
        
        if let image = image,
           let imageName = imageName{
            url = FileManagerPersistent.save(image, with: imageName)
        }
        
        let date = note?.date ?? Date()
        let (title, description) = createTitleAndDescription(from: text)
        let note = Note(title: title,
                        description: description,
                        date: date,
                        category: noteCategory,
                        imageURL: url )
        NotePersistent.save(note)
    }
    
    func delete() {
        guard let note = note else { return }
        
        if let url = note.imageURL {
            FileManagerPersistent.delete(from: url)
        }
        NotePersistent.delete(note)
    }
    
    func hasChanged(text: String, imageName: String?) -> Bool {
        let textChanged = self.text != text
        let categoryChanged = noteCategory != oldNoteCategory
        return (textChanged || categoryChanged || (imageName != nil)) && (text != "")
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
