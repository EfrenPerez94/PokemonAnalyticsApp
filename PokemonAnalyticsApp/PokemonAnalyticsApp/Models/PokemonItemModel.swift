//
//  PokemonItemModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation

struct PokemonItemModel: Codable, Equatable {
    let name: String
    let url: String
    var id: Int? {
        url.split(separator: "/").compactMap { Int($0) }.last
    }
    var imageURL: URL? {
        guard let id = id else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
