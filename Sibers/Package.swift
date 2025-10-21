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
                "View/main.swift",
                "Utils/Colorize.swift",
                "ViewModel/ViewModel.swift",
                "ViewModel/Services/MazeGeneratorService/MazeGeneratorService.swift",
                "ViewModel/Services/PlayerService/PlayerService.swift",
                "ViewModel/Services/PlayerService/PlayerService+Constants.swift",
                "Models/Direction.swift",
                "Models/Item.swift",
                "Models/Player.swift",
                "Models/Position.swift",
                "Models/Room.swift",
                "Models/World.swift",
                "Models/Command.swift",
                "Models/Food.swift"
            ]
        )
    ]
)
