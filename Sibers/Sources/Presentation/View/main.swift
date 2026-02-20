// main.swift
import Foundation

struct GameLauncher {
    static func start() {
        let viewModel = ViewModel()
        
        clearScreen()
        printGameInstructions()
        
        let roomCount = readPositiveInt(prompt: "Напишите количество комнат в лабиринте")
        viewModel.startGame(roomCount: roomCount)
        
        print(viewModel.roomDescription())
        gameLoop(viewModel: viewModel)
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
        — get [item] поднимает предмет в комнате и кладет его в инвентарь (кроме сундука); get gold добавляет монеты к вашей казне;
        — drop [item] бросает предмет в комнате, убирая его из инвентаря; drop gold выкидывает всё золото из казны.
        — eat [item] съедает пищу, и таким образом увеличивает свои жизненные силы;
        — open открывает сундук (требует ключ);
        — torchlight освещает темные комнаты;
        — в темной комнате без torchlight доступны только движения;
        
        """
        print(instructions)
    }
    private static func gameLoop(viewModel: ViewModel) {
        while viewModel.status == .playing {
            guard let input = readLine()?.uppercased(),
                  !input.isEmpty else { continue }
            
            switch viewModel.handleInput(input) {
            case .print(let message):
                if !message.isEmpty { print(message) }
            case .showRoom:
                print(viewModel.roomDescription())
            case .exit:
                return
            }
            
            if viewModel.status != .playing { return }
        }
    }
    
    private static func readPositiveInt(prompt: String) -> Int {
        while true {
            print(prompt)
            guard let line = readLine(),
                  let value = Int(line),
                  value > 0 else {
                print("Некорректный ввод. Попробуйте еще раз.")
                continue
            }
            return value
        }
    }
}
