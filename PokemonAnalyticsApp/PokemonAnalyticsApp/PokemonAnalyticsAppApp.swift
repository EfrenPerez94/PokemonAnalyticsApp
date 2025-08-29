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

//@main
//struct PokemonAnalyticsAppApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//    
//    
//}
