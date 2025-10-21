//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

import Foundation

final class PlayerService {
    
    func move(direction: Direction, in world: inout World) -> (success: Bool, message: String) {
        guard world.player.steps > 0 else {
            return (false, Constants.lose)
        }
        
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        
        guard room.doors.contains(direction) else {
            return (false, "Нет двери в направлении \(direction.rawValue)!")
        }
        
        let newPosition = moved(position: position, direction: direction)
        
        guard newPosition.x >= 0 && newPosition.y >= 0 &&
              newPosition.x < world.width && newPosition.y < world.height else {
            return (false, "")
        }
        
        world.player.position = newPosition
        world.player.steps -= 1
        return (true, "Переместились в направлении \(direction.rawValue)")
    }

    func openChest(in world: inout World) -> (success: Bool, message: String) {
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        
        guard room.items.contains(.chest) else {
            return (false, Constants.noChest)
        }
        
        guard world.player.inventory.contains(.key) else {
            return (false, Constants.noKey)
        }
        
        world.rooms[position.y][position.x].items.removeAll { $0 == .chest }
        return (true, Constants.won)
    }

    func getItem(in world: inout World, item: Item) -> String {
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        
        guard !room.items.isEmpty else {
            return Constants.getNothing
        }
        
        switch item {
        case .key:
            guard room.items.contains(.key) else {
                return Constants.getNoKey
            }
            
            world.rooms[position.y][position.x].items.removeAll { $0 == .key }
            world.player.inventory.append(.key)
            return Constants.getKey
            
        case .chest:
            return Constants.getChest
        }
    }
    
    func dropItem(in world: inout World, item: Item) -> String {
        let position = world.player.position
        let inventory = world.player.inventory
        guard !inventory.isEmpty else {
            return Constants.dropEmpty
        }
        switch item {
        case .key:
            guard world.player.inventory.contains(.key) else {
                return Constants.dropEmpty
            }
            
            world.player.inventory.removeAll { $0 == .key }
            world.rooms[position.y][position.x].items.append(.key)
            return Constants.dropItem
        case .chest:
            return ""
        }
    }
    
    func eating(in world: inout World, food: Food) -> String {
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        
        guard let roomFood = room.food else {
            return Constants.noEat
        }
        
        guard roomFood == food else {
            return "Здесь нет \(food.rawValue)!"
        }
        
        world.rooms[position.y][position.x].food = nil
        
        switch food {
        case .meat:
            world.player.steps += 7
        case .fish:
            world.player.steps += 5
        case .bread:
            world.player.steps += 3
        }
        
        return "Вы съели \(food.rawValue)! Теперь у вас больше энергии.".green()
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
