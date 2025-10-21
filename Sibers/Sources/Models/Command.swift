//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 20.10.2025.
//

enum Command {
    case quit
    case get(Item)
    case drop(Item)
    case eat(Food)
    case open
    case move(Direction)
    case unknown
    
    init(from input: String) {
        let parts = input.split(separator: " ", maxSplits: 1)
        let command = parts[0]
        
        switch command {
        case "QUIT": self = .quit
        case "GET":
            let value = parts.count > 1 ? String(parts[1]).uppercased() : ""
            if let item = Item(rawValue: value) { self = .get(item) } else { self = .unknown }
        case "DROP":
            let value = parts.count > 1 ? String(parts[1]).uppercased() : ""
            if let item = Item(rawValue: value) { self = .drop(item) } else { self = .unknown }
        case "EAT":
            let value = parts.count > 1 ? String(parts[1]).uppercased() : ""
            if let food = Food(rawValue: value) {
                self = .eat(food)
            } else {
                self = .unknown
            }
        case "OPEN": self = .open
        case "N", "S", "E", "W":
            self = .move(Direction(rawValue: input)!)
        default: self = .unknown
        }
    }
}
