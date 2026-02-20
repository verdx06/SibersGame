// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sibers",
    products: [
        .executable(name: "Sibers", targets: ["Sibers"]),
    ],
    targets: [
        .executableTarget(
            name: "Sibers",
            path: "Sources",
            sources: [
                "Utils/Colorize.swift",
                "Presentation/View/main.swift",
                "Presentation/ViewModel/ViewModel.swift",
                "Presentation/Helpers/RoomState.swift",
                "Domain/Services/MazeGeneratorService/MazeGeneratorService.swift",
                "Domain/Services/PlayerService/PlayerService.swift",
                "Domain/Services/PlayerService/PlayerService+Constants.swift",
                "Domain/Models/Direction.swift",
                "Domain/Models/Item.swift",
                "Domain/Models/Player.swift",
                "Domain/Models/Position.swift",
                "Domain/Models/GameStatus.swift",
                "Domain/Models/Room.swift",
                "Domain/Models/Command.swift",
                "Domain/Models/Food.swift"
            ]
        )
    ]
)
