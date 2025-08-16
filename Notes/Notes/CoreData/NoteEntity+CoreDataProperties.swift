//
//  NoteEntity+CoreDataProperties.swift
//  Notes
//
//  Created by Кристина Олейник on 14.08.2025.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageUrl: URL?
    @NSManaged public var category: Int16

}

extension NoteEntity : Identifiable {

}
