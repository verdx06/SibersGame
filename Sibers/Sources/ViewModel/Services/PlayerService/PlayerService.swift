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
        var items = world.rooms[position.y][position.x].items
        if !items.isEmpty && items.contains(where: { $0 == Item.chest }) {
            guard world.player.inventory.contains(where: { $0 == Item.key }) else {
                return (false, Constants.noKey)
            }
            items.removeFirst()
            world.rooms[position.y][position.x].items = items
            return (true, Constants.won)
        }
        return (false, Constants.noChest)
    }

    func getItem(in world: inout World, item: Item) -> String {
           let position = world.player.position
           var items = world.rooms[position.y][position.x].items
           guard !items.isEmpty else { return Constants.getNothing }
           switch item {
               case .key:
                       items.removeFirst()
                       world.rooms[position.y][position.x].items = items
                       world.player.inventory.append(.key)
                       return Constants.getKey
           case .chest:
                   return ""
           }
       }
    
    func dropItem(in world: inout World, item: Item) -> String {
        let position = world.player.position
        var playerInventory = world.player.inventory
        guard !playerInventory.isEmpty else { return Constants.dropEmpty }
        switch item {
            case .key:
                    playerInventory.removeAll { $0 == .key }
                    world.rooms[position.y][position.x].items.append(.key)
                    return Constants.dropItem
            case .chest:
                return ""
        }
    }
    
    func eating(in world: inout World, food: Food) -> String {
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        guard (room.food != nil) else {
            return Constants.noEat
        }
        switch food {
            case .meat:
                    world.rooms[position.y][position.x].food = nil
                    world.player.steps += 7
        case .fish:
            world.rooms[position.y][position.x].food = nil
            world.player.steps += 5
        case .bread:
            world.rooms[position.y][position.x].food = nil
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
