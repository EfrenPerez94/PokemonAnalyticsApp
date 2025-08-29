//
//  PokemonDetailModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

/// Full Pokémon detail as returned by PokeAPI.
/// The decoder uses `.convertFromSnakeCase`, so snake_case JSON maps to camelCase automatically.

struct PokemonDetailModel: Codable, Identifiable, Equatable {

    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [TypeSlot]
    let stats: [StatSlot]
    let abilities: [AbilitySlot]

    var spriteURL: URL? {
        if let shiny = sprites.frontShiny, let url = URL(string: shiny) {
            return url
        }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }

    var typeNames: [String] {
        types.sorted { $0.slot < $1.slot }.map { $0.type.name }
    }

    var statsDict: [String: Int] {
        Dictionary(uniqueKeysWithValues: stats.map { ($0.stat.name, $0.baseStat) })
    }

    struct Sprites: Codable, Equatable {
        let frontShiny: String?
    }

    struct TypeSlot: Codable, Equatable {
        let slot: Int
        let type: PokemonItemModel
    }

    struct StatSlot: Codable, Equatable {
        let baseStat: Int
        let effort: Int
        let stat: PokemonItemModel
    }

    struct AbilitySlot: Codable, Equatable {
        let isHidden: Bool
        let slot: Int
        let ability: PokemonItemModel
    }
}
