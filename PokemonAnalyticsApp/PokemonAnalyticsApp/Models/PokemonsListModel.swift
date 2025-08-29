//
//  PokemonsListModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

struct PokemonsListModel: Codable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItemModel]
}
