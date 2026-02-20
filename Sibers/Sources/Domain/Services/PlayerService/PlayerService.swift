//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

import Foundation

final class PlayerService {
    func move(
        direction: Direction,
        player: inout Player,
        rooms: [[Room]],
        width: Int,
        height: Int
    ) -> ActionResult {
        guard player.steps > 0 else {
            return .ended(.lost, Constants.lose)
        }
        
        let position = player.position
        let room = rooms[position.y][position.x]
        
        guard room.doors.contains(direction) else {
            return .failure("Нет двери в направлении \(direction.rawValue)!")
        }
        
        let newPosition = moved(position: position, direction: direction)
        
        guard newPosition.x >= 0 && newPosition.y >= 0 &&
              newPosition.x < width && newPosition.y < height else {
            return .failure("")
        }
        
        player.position = newPosition
        player.steps -= 1
        return .success
    }

    func openChest(
        player: inout Player,
        rooms: inout [[Room]]
    ) -> ActionResult {
        let position = player.position
        let room = rooms[position.y][position.x]
        
        guard room.items.contains(.chest) else {
            return .failure(Constants.noChest)
        }
        
        guard player.inventory.contains(.key) else {
            return .failure(Constants.noKey)
        }
        
        rooms[position.y][position.x].items.removeAll { $0 == .chest }
        return .ended(.won, Constants.won)
    }

    func getItem(
        player: inout Player,
        rooms: inout [[Room]],
        item: Item
    ) -> String {
        let position = player.position
        let room = rooms[position.y][position.x]
        
        guard !room.items.isEmpty else {
            return Constants.getNothing
        }
        
        switch item {
        case .key:
            guard room.items.contains(.key) else {
                return Constants.getNoKey
            }
            
            rooms[position.y][position.x].items.removeAll { $0 == .key }
            player.inventory.append(.key)
            return Constants.getKey
            
        case .chest:
            return Constants.getChest
            
        case .torchlight:
            guard room.items.contains(.torchlight) else {
                return Constants.getNoTorchlight
            }
            
            rooms[position.y][position.x].items.removeAll { $0 == .torchlight }
            player.inventory.append(.torchlight)
            return Constants.getTorchlight
        }
    }
    
    func dropItem(
        player: inout Player,
        rooms: inout [[Room]],
        item: Item
    ) -> String {
        let position = player.position
        let inventory = player.inventory
        guard !inventory.isEmpty else {
            return Constants.dropEmpty
        }
        switch item {
        case .key:
            guard player.inventory.contains(.key) else {
                return Constants.dropEmpty
            }
            
            player.inventory.removeAll { $0 == .key }
            rooms[position.y][position.x].items.append(.key)
            return Constants.dropItem
        case .chest:
            return ""
        case .torchlight:
            guard player.inventory.contains(.torchlight) else {
                return Constants.dropEmpty
            }
            
            player.inventory.removeAll { $0 == .torchlight }
            rooms[position.y][position.x].items.append(.torchlight)
            if rooms[position.y][position.x].isDark {
                rooms[position.y][position.x].isLit = true
            }
            return Constants.dropItem
        }
    }
    
    func eating(
        player: inout Player,
        rooms: inout [[Room]],
        food: Food
    ) -> String {
        let position = player.position
        let room = rooms[position.y][position.x]
        
        guard let roomFood = room.food else {
            return Constants.noEat
        }
        
        guard roomFood == food else {
            return "Здесь нет \(food.rawValue)!"
        }
        
        rooms[position.y][position.x].food = nil
        
        switch food {
        case .meat:
            player.steps += 7
        case .fish:
            player.steps += 5
        case .bread:
            player.steps += 3
        }
        
        return "Вы съели \(food.rawValue)! Теперь у вас больше энергии.".green
    }

    func moved(position: Position, direction: Direction) -> Position {
        switch direction {
        case .N: return Position(x: position.x, y: position.y - 1)
        case .S: return Position(x: position.x, y: position.y + 1)
        case .E: return Position(x: position.x + 1, y: position.y)
        case .W: return Position(x: position.x - 1, y: position.y)
        }
    }
}

extension PlayerService {
    enum ActionResult {
        case success
        case failure(String)
        case ended(GameStatus, String)
        
        var status: GameStatus {
            switch self {
            case .success, .failure: return .playing
            case .ended(let s, _): return s
            }
        }
    }
}
