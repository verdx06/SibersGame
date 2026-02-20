//
//  RoomState.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 20.02.2026.
//

struct RoomState {
    let position: Position
    let room: Room
    let steps: Int
    let hasTorchlight: Bool
    
    var isMoveOnly: Bool {
        room.isDark && !room.isLit && !hasTorchlight
    }
}
