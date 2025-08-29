//
//  PokemonAnalyticsAppApp.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import SwiftUI
import SwiftData

@main
struct PokemonAnalyticsApp: App {
    var body: some Scene {
        WindowGroup {
            UIKitRootView()
                .modelContainer(for: FavoritePokemon.self)
        }
    }
}
