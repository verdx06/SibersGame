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
    
    init(
        mazeGenerator: MazeGeneratorService = MazeGeneratorService(),
        playerService: PlayerService = PlayerService()
    ) {
        self.mazeGenerator = mazeGenerator
        self.playerService = playerService
    }
    
    func getSize(_ message: String) -> Int {
        return mazeGenerator.getSize(message)
    }
    
    func getRoomCount(_ message: String) -> Int {
        return mazeGenerator.getRoomCount(message)
    }
    
    func createMaze(roomCount: Int) -> World {
        return mazeGenerator.createMaze(roomCount: roomCount)
    }
    
    func descriptionCurrentRoom(_ world: World) {
        mazeGenerator.descriptionCurrentRoom(world)
    }
    
    func move(direction: Direction, in world: inout World) -> (success: Bool, message: String) {
        return playerService.move(direction: direction, in: &world)
    }
    
    func openChest(in world: inout World) -> (success: Bool, message: String) {
        return playerService.openChest(in: &world)
    }
    
    func getItem(in world: inout World, item: Item) -> String {
        return playerService.getItem(in: &world, item: item)
    }
    
    func dropItem(in world: inout World, item: Item) -> String {
        return playerService.dropItem(in: &world, item: item)
    }
    
    func eating(in world: inout World, food: Food) -> String {
        return playerService.eating(in: &world, food: food)
    }
}
