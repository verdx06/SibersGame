//
//  File.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

extension PlayerService {
    struct Constants {
        static let lose = "Вы проиграли.".red
        static let won = "Вы выиграли!".green.bold
        static let unknownCommand = "Неизвестная команда.".yellow
        static let getKey = "Вы подобрали ключ!".green
        static let getTorchlight = "Вы подобрали torchlight!".green
        static let getChest = "Сундук нельзя подобрать! Используйте команду 'open' чтобы открыть его.".yellow
        static let getNothing = "В этой комнате нечего поднимать.".yellow
        static let getNoKey = "В этой комнате нет ключа.".red
        static let getNoTorchlight = "В этой комнате нет torchlight.".red
        static let getNoGold = "В этой комнате нет золота.".red
        static func getGold(amount: Int) -> String {
            "Вы подобрали золото! +\(amount) монет.".green
        }
        static let dropItem = "Вы выбросили предмет.".cyan
        static func dropGold(amount: Int) -> String {
            "Вы выбросили \(amount) монет.".cyan
        }
        static let dropNoGold = "У вас нет золота.".yellow
        static let dropEmpty = "У вас нет предметов.".yellow
        static let dropNo = "У вас нет такого предмета!".yellow
        static let noKey = "У вас нет ключа.".red
        static let noChest = "В этой комнате нет сундука.".yellow
        static let noEat = "В этой комнате нет еды.".yellow
    }
}
