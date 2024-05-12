//
//  TabModel.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

enum Tab: String, CaseIterable {
    case favorite = "Favorite"
    case search = "Search"
    
    var icon: String {
        switch self {
        case .favorite:
            "star.fill"
        case .search:
            "magnifyingglass"
        }
    }
}
