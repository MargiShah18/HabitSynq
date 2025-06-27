//
//  Item.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-27.
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
