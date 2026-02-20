//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 20.10.2025.
//

import Foundation

final class ViewModel {
    
    private let mazeGenerator: MazeGeneratorService
    private let playerService: PlayerService
    private var rooms: [[Room]] = []
    private var player = Player(position: Position(x: 0, y: 0), inventory: [], steps: 0)
    private var width: Int = 0
    private var height: Int = 0
    
    private(set) var status: GameStatus = .playing
    
    init(
        mazeGenerator: MazeGeneratorService = MazeGeneratorService(),
        playerService: PlayerService = PlayerService()
    ) {
        self.mazeGenerator = mazeGenerator
        self.playerService = playerService
    }
    
    func startGame(roomCount: Int) {
        let maze = mazeGenerator.createMaze(roomCount: roomCount)
        rooms = maze.rooms
        player = maze.player
        width = maze.width
        height = maze.height
        status = .playing
    }
    
    private func currentRoomState() -> RoomState {
        let position = player.position
        let room = rooms[position.y][position.x]
        return RoomState(
            position: position,
            room: room,
            steps: player.steps,
            hasTorchlight: player.inventory.contains(.torchlight)
        )
    }
    
    func roomDescription() -> String {
        let state = currentRoomState()
        if state.isMoveOnly {
            return "Can't see anything in this dark place!" +
                "\nSteps: ".bold +
                "\(state.steps)".red
        }
        let directions = state.room.doors.map { $0.rawValue }.sorted().joined(separator: ", ")
        var allItems = state.room.items.map { $0.rawValue.lowercased() }
        if let food = state.room.food {
            allItems.append(food.rawValue.lowercased())
        }
        let items = allItems.joined(separator: ", ")
        return "You are in the room [\(state.position.x), \(state.position.y)]. ".cyan +
            "There are [\(state.room.doors.count)] doors: ".yellow +
            "[\(directions)]. ".green +
            "Items in the room: ".blue +
            "[\(items)].".magenta +
            "\nSteps: ".bold +
            "\(state.steps)".red
    }
    
    func handleInput(_ input: String) -> InputAction {
        let state = currentRoomState()
        
        guard let command = Command(from: input) else {
            let message = state.isMoveOnly ? roomDescription() : PlayerService.Constants.unknownCommand
            return .print(message)
        }
        
        if state.isMoveOnly && !isAllowedInDark(command) {
            return .print(roomDescription())
        }
        
        return execute(command)
    }
    
    private func isAllowedInDark(_ command: Command) -> Bool {
        switch command {
        case .move, .quit: return true
        default: return false
        }
    }
    
    private func execute(_ command: Command) -> InputAction {
        switch command {
        case .quit:
            return .exit
        case .get(let item):
            return .print(getItem(item: item))
        case .drop(let item):
            return .print(dropItem(item: item))
        case .open:
            let result = openChest()
            status = result.status
            switch result {
            case .success: return .showRoom
            case .failure(let msg), .ended(_, let msg): return .print(msg)
            }
        case .eat(let food):
            return .print(eating(food: food))
        case .move(let direction):
            let result = move(direction: direction)
            status = result.status
            switch result {
            case .success: return .showRoom
            case .failure(let msg): return .print(msg)
            case .ended(_, let msg): return .print(msg)
            }
        }
    }
    
    private func move(direction: Direction) -> PlayerService.ActionResult {
        playerService.move(
            direction: direction,
            player: &player,
            rooms: rooms,
            width: width,
            height: height
        )
    }
    
    private func openChest() -> PlayerService.ActionResult {
        playerService.openChest(player: &player, rooms: &rooms)
    }
    
    func getItem(item: Item) -> String {
        return playerService.getItem(player: &player, rooms: &rooms, item: item)
    }
    
    func dropItem(item: Item) -> String {
        return playerService.dropItem(player: &player, rooms: &rooms, item: item)
    }
    
    func eating(food: Food) -> String {
        return playerService.eating(player: &player, rooms: &rooms, food: food)
    }
}

extension ViewModel {
    enum InputAction {
        case print(String)
        case showRoom
        case exit
    }
}
