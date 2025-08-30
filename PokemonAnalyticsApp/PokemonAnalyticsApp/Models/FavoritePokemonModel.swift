//
//  Item.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import Foundation
import SwiftData

@Model
final class FavoritePokemon {

    @Attribute(.unique) var id: Int
    var name: String
    var url: String

    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }

    var imageURL: URL? {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }

}
