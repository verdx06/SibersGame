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
    
    init?(from input: String) {
        let parts = input.split(separator: " ", maxSplits: 1)
        guard let command = parts.first else { return nil }
        
        switch command {
        case "QUIT": self = .quit
        case "GET":
            guard parts.count > 1, let item = Item(rawValue: String(parts[1])) else { return nil }
            self = .get(item)
        case "DROP":
            guard parts.count > 1, let item = Item(rawValue: String(parts[1])) else { return nil }
            self = .drop(item)
        case "EAT":
            guard parts.count > 1, let food = Food(rawValue: String(parts[1])) else { return nil }
            self = .eat(food)
        case "OPEN": self = .open
        case "N", "S", "E", "W":
            guard let direction = Direction(rawValue: String(command)) else { return nil }
            self = .move(direction)
        default: return nil
        }
    }
}
