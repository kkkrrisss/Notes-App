//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Кристина Олейник on 12.08.2025.
//

import Foundation

protocol NotesListViewModelProtocol {
    var section: [TableViewSection] { get }
}

final class NotesListViewModel: NotesListViewModelProtocol {
    private(set) var section: [TableViewSection] = []
    
    init() {
        getNotes()
        setMocks()
    }
    
    private func getNotes() {
        
    }
    
    private func setMocks() {
        let section = TableViewSection(title: "23 Apr 2025",
                                       items: [
                                        Note(title: "First Note",
                                                    description: "First Note description",
                                                    date: Date(),
                                                    imageURL: nil,
                                                    image: nil),
                                        Note(title: "Second Note",
                                                    description: "Second Note description",
                                                    date: Date(),
                                                    imageURL: nil,
                                                    image: nil)
                                       ])
        
        self.section = [section]
    }
}
