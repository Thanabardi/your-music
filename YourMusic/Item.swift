//
//  Item.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
