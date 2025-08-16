//
//  NotePersistent.swift
//  Notes
//
//  Created by Кристина Олейник on 14.08.2025.
//

import UIKit
import CoreData

final class NotePersistent: NSManagedObject {
    private static let context = AppDelegate.persistentContainer.viewContext
    
    static func save(_ note: Note) {
        var entity: NoteEntity?
        if let ent = getEntity(for: note) {
            entity = ent
        } else {
            guard let description = NSEntityDescription.entity(forEntityName: "NoteEntity",
                                                               in: context) else { return }
            entity = NoteEntity(entity: description,
                                    insertInto: context)
        }
        
        
        entity?.title = note.title
        entity?.text = note.description
        entity?.date = note.date
        entity?.category = Int16(note.category.rawValue)
        entity?.imageUrl = note.imageURL
        
        saveContext()
    
    }
    
    static func delete(_ note: Note) {
        guard let entity = getEntity(for: note) else { return }
        context.delete(entity)
        saveContext()
    }
    
    static func fetchAll() -> [Note] {
        let request = NoteEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            return convert(entities: objects)
        } catch let error {
            debugPrint("Fetch notes error: \(error)")
            return []
        }
    }
    
    //MARK: - Private methods
    private static func convert(entities: [NoteEntity]) -> [Note] {
        let notes = entities.map {
            Note(title: $0.title ?? "",
                 description: $0.text,
                 date: $0.date ?? Date(),
                 category: Category(rawValue: Int($0.category)) ?? .personal,
                 imageURL: $0.imageUrl)
        }
        return notes
    }
    
    private static func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Update"),
                                        object: nil)
    }
    
    private static func getEntity(for note: Note) -> NoteEntity? {
        let request = NoteEntity.fetchRequest()
        let predicate = NSPredicate(format: "date = %@", note.date as NSDate)
        request.predicate = predicate
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch let error {
            debugPrint("Fetch notes error: \(error)")
            return nil
        }
    }
    
    private static func saveContext() {
        do {
            try context.save()
            postNotification()
        } catch let error {
            debugPrint("Save note error: \(error)")
        }
    }
}
