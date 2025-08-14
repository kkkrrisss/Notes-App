//
//  TableViewSection.swift
//  Notes
//
//  Created by Кристина Олейник on 13.08.2025.
//

import Foundation

protocol TableViewItemProtocol { }

struct TableViewSection {
    var title: String?
    var items: [TableViewItemProtocol]
}
