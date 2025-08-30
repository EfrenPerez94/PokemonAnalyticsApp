//
//  RequestState.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

/// Request state machine
enum RequestState<T>: Equatable where T: Equatable {
    case idle
    case fetching
    case loaded(T)
    case failed(AppError)

    static func == (left: Self, right: Self) -> Bool {
        switch (left, right) {
        case (.idle, .idle), (.fetching, .fetching): return true
        case (.loaded(let value1), .loaded(let value2)): return value1 == value2
        case (.failed(let error1), .failed(let error2)): return error1 == error2
        default: return false
        }
    }
}
