//
//  EnumCategoryNote.swift
//  Notes
//
//  Created by Кристина Олейник on 14.08.2025.
//

import UIKit

enum Category: Int, CaseIterable {
    case personal = 0
    case work = 1
    case study = 2
    case hobby = 3
    case lists = 4
    
    var colorCategory: UIColor {
        switch self {
        case .personal:
            return .lightYellow
        case .work:
            return .lightRed
        case .study:
            return .lightBlue
        case .hobby:
            return .lightPink
        case .lists:
            return .lightGreen
        }
    }
    
    var getStringCategory: String {
        switch self {
        case .personal:
            return "Personal"
        case .work:
            return "Work"
        case .study:
            return "Study"
        case .hobby:
            return "Hobby"
        case .lists:
            return "Lists"
        }
    }
}
