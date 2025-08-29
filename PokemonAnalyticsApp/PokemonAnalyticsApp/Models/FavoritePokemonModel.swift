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
    var dateAdded: Date

    init(id: Int, name: String, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.dateAdded = dateAdded
    }

}
