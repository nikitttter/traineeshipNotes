//
//  File.swift
//  Notes
//
//  Created by Nikita Yakovlev on 08.05.2022.
//

enum ItemState {
    case main, additional

    mutating func toggle() {
        switch self {
        case .main:
            self = .additional
        case .additional:
            self = .main
        }
    }
}
