//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 20.10.2025.
//

import Foundation

struct Room {
    var doors: Set<Direction>
    var items: [Item]
    var food: Food?
}
