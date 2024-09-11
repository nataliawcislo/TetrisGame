//
//  Item.swift
//  TetrisGame
//
//  Created by Natalia on 12.09.24.
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
