//
//  Note.swift
//  Notes
//
//  Created by Кристина Олейник on 12.08.2025.
//

import Foundation

struct Note: TableViewItemProtocol {
    let title: String
    let description: String
    let date: Date
    let imageURL: String?
    let image: Data?
}
