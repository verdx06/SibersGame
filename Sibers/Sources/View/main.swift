// main.swift
import Foundation

struct GameLauncher {
    static func start() {
        let viewModel = ViewModel()
        
        clearScreen()
        printGameInstructions()
        
        let roomCount = viewModel.getRoomCount("Напишите количество комнат в лабиринте")
        var world = viewModel.createMaze(roomCount: roomCount)
        
        viewModel.descriptionCurrentRoom(world)
        gameLoop(viewModel: viewModel, world: &world)
    }
}

GameLauncher.start()

private extension GameLauncher {
    private static func clearScreen() {
        print("\u{001B}[2J\u{001B}[H")
    }
    
    private static func printGameInstructions() {
        let instructions = """
        Доступные команды:
        — N, S, W и E перемещают игрока в соответствующем направлении;
        — get [item] поднимает предмет в комнате и кладет его в инвентарь (кроме сундука);
        — drop [item] бросает предмет в комнате, убирая его из инвентаря.
        — eat [item] съедает пищу, и таким образом увеличивает свои жизненные силы;
        — open открывает сундук (требует ключ);
        
        """
        print(instructions)
    }
    private static func gameLoop(viewModel: ViewModel, world: inout World) {
        while true {
            guard let input = readLine()?.uppercased(),
                  !input.isEmpty else { continue }
                  
            let command = Command(from: input)
            
            switch command {
            case .quit:
                return
                
            case .get(let item):
                print(viewModel.getItem(in: &world, item: item))
                
            case .drop(let item):
                print(viewModel.dropItem(in: &world, item: item))
                
            case .open:
                let result = viewModel.openChest(in: &world)
                print(result.message)
                if result.success { return }
                
            case .eat(let food):
                print(viewModel.eating(in: &world, food: food))
                
            case .move(let direction):
                let result = viewModel.move(direction: direction, in: &world)
                if !result.success {
                    if !result.message.isEmpty { print(result.message) }
                    if result.message == PlayerService.Constants.lose { return }
                } else {
                    viewModel.descriptionCurrentRoom(world)
                }
                
            case .unknown:
                print(PlayerService.Constants.unknownCommand)
            }
        }
    }
}
