//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

import Foundation

final class MazeGeneratorService {
    func createMaze(roomCount: Int) -> (rooms: [[Room]], player: Player, width: Int, height: Int) {
        let (h, w) = calculateOptimalDimensions(roomCount: roomCount)
        let maze = generateMaze(height: h, width: w, roomCount: roomCount)
        return (maze.rooms, maze.player, w, h)
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
}

private extension MazeGeneratorService {
    
    func generateMaze(height: Int, width: Int, roomCount: Int) -> (rooms: [[Room]], player: Player) {
        let activePositions = buildActivePositions(height: height, width: width, roomCount: roomCount)
        let activeSet = Set(activePositions)
        let darkPositions = selectDarkPositions(from: activePositions, roomCount: roomCount)
        
        var rooms: [[Room]] = (0..<height)
            .map { _ in
                (0..<width)
                    .map { _ in
                        Room(
                            doors: [],
                            items: [],
                            food: nil
                        )
                    }
            }
        
        for position in activePositions {
            var doors: Set<Direction> = []
            let x = position.x
            let y = position.y
            
            if activeSet.contains(Position(x: x, y: y - 1)) { doors.insert(.N) }
            if activeSet.contains(Position(x: x, y: y + 1)) { doors.insert(.S) }
            if activeSet.contains(Position(x: x - 1, y: y)) { doors.insert(.W) }
            if activeSet.contains(Position(x: x + 1, y: y)) { doors.insert(.E) }
            
            rooms[y][x].doors = doors
            rooms[y][x].isDark = darkPositions.contains(position)
        }
        
        let player = Player(
            position: Position(x: 0, y: 0),
            inventory: [],
            steps: roomCount
        )
        
        func randomActivePosition() -> Position {
            guard let position = activePositions.randomElement() else {
                return Position(x: 0, y: 0)
            }
            return position
        }
        
        let keyPosition = randomActivePosition()
        let chestPosition: Position = {
            guard activePositions.count > 1 else { return keyPosition }
            var position = randomActivePosition()
            while position == keyPosition {
                position = randomActivePosition()
            }
            return position
        }()
        
        let foodPosition: Position? = (roomCount > 12) ? randomActivePosition() : nil
        let torchPosition = selectTorchPosition(from: activePositions, darkPositions: darkPositions)
        
        if let foodPos = foodPosition {
            let foodTypes: [Food] = [.meat, .fish, .bread]
            let randomIndex = Int.random(in: 0..<foodTypes.count)
            rooms[foodPos.y][foodPos.x].food = foodTypes[randomIndex]
        }

        if let torchPos = torchPosition {
            rooms[torchPos.y][torchPos.x].items.append(.torchlight)
        }
        
        rooms[keyPosition.y][keyPosition.x].items.append(.key)
        rooms[chestPosition.y][chestPosition.x].items.append(.chest)
        
        return (rooms, player)
    }
    
    func buildActivePositions(height: Int, width: Int, roomCount: Int) -> [Position] {
        var positions: [Position] = []
        positions.reserveCapacity(roomCount)
        
        for y in 0..<height {
            for x in 0..<width {
                guard positions.count < roomCount else { return positions }
                positions.append(Position(x: x, y: y))
            }
        }
        
        return positions
    }
    
    func selectDarkPositions(from activePositions: [Position], roomCount: Int) -> Set<Position> {
        guard roomCount >= 4 else { return [] }
        let candidates = activePositions.filter { $0 != Position(x: 0, y: 0) }
        guard let random = candidates.randomElement() else { return [] }
        return [random]
    }
    
    func selectTorchPosition(from activePositions: [Position], darkPositions: Set<Position>) -> Position? {
        let candidates = activePositions.filter { !darkPositions.contains($0) }
        return candidates.randomElement()
    }
    
}
