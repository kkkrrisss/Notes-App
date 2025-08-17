//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Кристина Олейник on 12.08.2025.
//

import Foundation

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
    var reloadTable: (() -> Void)? { get set }
    
    func getNotes()
}

final class NotesListViewModel: NotesListViewModelProtocol {
    
    //MARK: - Properties
    var reloadTable: (() -> Void)?
    
    private(set) var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    //MARK: - Initialization
    init() {
        getNotes()
        //setMocks()
    }
    
    //MARK: - Private methods
    func getNotes() {
        let notes = NotePersistent.fetchAll()
        section = []
        //print(notes)
        let sortedNotes = notes.sorted { $0.date > $1.date }
        
        let groupedObjects = sortedNotes.reduce(into: [Date: [Note]]()) { result, note in
            let date = Calendar.current.startOfDay(for: note.date)
            result[date, default: []].append(note)
        }
        
        let keys = groupedObjects.keys.sorted(by: >)
        print(keys)
        keys.forEach { key in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let stringDate = dateFormatter.string(from: key)
            section.append(TableViewSection(title: stringDate,
                                            items: groupedObjects[key] ?? []))
        }
        
    }
    
    private func setMocks() {
        let section = TableViewSection(title: "23 Apr 2025",
                                       items: [
                                        Note(title: "First Note",
                                             description: "First Note description",
                                             date: Date(),
                                             category: .hobby,
                                             imageURL: nil),
                                        Note(title: "Second Note",
                                             description: "Second Note description",
                                             date: Date(),
                                             category: .personal,
                                             imageURL: nil)
                                       ])
        
        self.section = [section]
    }
}
