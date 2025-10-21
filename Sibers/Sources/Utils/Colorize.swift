//
//  Colorize.swift
//  Sibers
//
//  Created by Виталий Багаутдинов on 21.10.2025.
//

struct Colorize {
    static let black = "\u{001B}[0;30m"
    static let red = "\u{001B}[0;31m"
    static let green = "\u{001B}[0;32m"
    static let yellow = "\u{001B}[0;33m"
    static let blue = "\u{001B}[0;34m"
    static let magenta = "\u{001B}[0;35m"
    static let cyan = "\u{001B}[0;36m"
    static let white = "\u{001B}[0;37m"
    static let reset = "\u{001B}[0m"
    
    static let bold = "\u{001B}[1m"
    static let underline = "\u{001B}[4m"
}

extension String {
    func red() -> String { "\(Colorize.red)\(self)\(Colorize.reset)" }
    func green() -> String { "\(Colorize.green)\(self)\(Colorize.reset)" }
    func yellow() -> String { "\(Colorize.yellow)\(self)\(Colorize.reset)" }
    func blue() -> String { "\(Colorize.blue)\(self)\(Colorize.reset)" }
    func cyan() -> String { "\(Colorize.cyan)\(self)\(Colorize.reset)" }
    func magenta() -> String { "\(Colorize.magenta)\(self)\(Colorize.reset)" }
    func bold() -> String { "\(Colorize.bold)\(self)\(Colorize.reset)" }
}
