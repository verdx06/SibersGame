//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

import Foundation

final class MazeGeneratorService {
    
    func getSize(_ message: String) -> Int {
        print(message)
        guard let line = readLine(), let size = Int(line) else {
            return 3
        }
        return size
    }
    
    func getRoomCount(_ message: String) -> Int {
        print(message)
        guard let line = readLine(), let count = Int(line), count > 0 else {
            return 9
        }
        return count
    }

    func createMaze(roomCount: Int) -> World {
        let (h, w) = calculateOptimalDimensions(roomCount: roomCount)
        return generateMaze(h, w)
    }
    
    private func calculateOptimalDimensions(roomCount: Int) -> (height: Int, width: Int) {
        let sqrt = Int(Double(roomCount).squareRoot().rounded(.up))
        
        if sqrt * sqrt == roomCount {
            return (sqrt, sqrt)
        }
        
        var bestHeight = sqrt
        var bestWidth = sqrt
        
        for height in 1...sqrt {
            for width in 1...sqrt {
                if height * width >= roomCount {
                    if height * width < bestHeight * bestWidth ||
                       (height * width == bestHeight * bestWidth && abs(height - width) < abs(bestHeight - bestWidth)) {
                        bestHeight = height
                        bestWidth = width
                    }
                }
            }
        }
        
        return (bestHeight, bestWidth)
    }
    
    func descriptionCurrentRoom(_ world: World) {
        let position = world.player.position
        let room = world.rooms[position.y][position.x]
        let directions = room.doors.map { $0.rawValue }.sorted().joined(separator: ", ")
        let items = room.items.map { "\($0)" }.joined(separator: ", ")
        let eatInfo = room.food != nil ? "\nEat: \(room.food!)" : ""
        print("You are in the room [\(position.x), \(position.y)].".cyan() +
              "There are [\(room.doors.count)] doors:".yellow() +
              " [\(directions)].".green() +
              "Items in the room:".blue() +
              " [\(items)]".magenta() +
              "\(eatInfo)".green() +
              "\nSteps:".bold() +
              " \(world.player.steps)".red())
    }
    
}

private extension MazeGeneratorService {
    
    func generateMaze(_ h: Int, _ w: Int) -> World {
        
        let totalRooms = h*w
        
        var rooms: [[Room]] = (0..<h)
            .map { _ in
                (0..<w)
                    .map { _ in
                        Room(
                            doors: [],
                            items: [],
                            food: nil
                        )
                    }
            }
        
        let player = Player(
            position: Position(x: 0, y: 0),
            inventory: [],
            steps: totalRooms
        )
        
        func randomPosition() -> Position {
            Position(x: Int.random(in: 0..<w), y: Int.random(in: 0..<h))
        }
        
        let keyPosition = randomPosition()
        let chestPosition = {
            var position = randomPosition()
            while position == keyPosition {
                position = randomPosition()
            }
            return position
        }()
        
        let foodPosition: Position? = (totalRooms > 12) ? randomPosition() : nil
        
        for y in 0..<h {
            for x in 0..<w {
                var doors: Set<Direction> = []
                
                if y > 0 { doors.insert(.N) }
                if y < h - 1 { doors.insert(.S) }
                if x > 0 { doors.insert(.W) }
                if x < w - 1 { doors.insert(.E) }
                
                rooms[y][x].doors = doors
            }
        }
        
        if let foodPos = foodPosition {
            let foodTypes: [Food] = [.meat, .fish, .bread]
            let randomIndex = Int.random(in: 0..<foodTypes.count)
            rooms[foodPos.y][foodPos.x].food = foodTypes[randomIndex]
        }
        
        rooms[keyPosition.y][keyPosition.x].items.append(.key)
        rooms[chestPosition.y][chestPosition.x].items.append(.chest)
        
        return World(
            width: w,
            height: h,
            rooms: rooms,
            player: player
        )
    }
    
}
