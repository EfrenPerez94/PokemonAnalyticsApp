//
//  FavoritesViewModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 30/08/25.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var items: [FavoritePokemon] = []
    @Published var error: AppError?

    private let context: ModelContext
    private let api: PokeAPI

    init(context: ModelContext, api: PokeAPI) {
        self.context = context
        self.api = api
    }

    func loadFavorites() {
        do {
            let pokemon = FetchDescriptor<FavoritePokemon>( sortBy: [SortDescriptor(\.id)])
            let result = try context.fetch(pokemon)
            items = result
            self.error = nil
        } catch {
            self.error = .persistence(error.localizedDescription)
        }
    }

    func remove(at offset: IndexSet) {
        do {
            for index in offset {
                let pokemonId = items[index].id
                let pokemon = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == pokemonId })
                if let fav = try context.fetch(pokemon).first {
                    context.delete(fav)
                }
            }
            try context.save()
            loadFavorites()
        } catch {
            self.error = .persistence(error.localizedDescription)
        }
    }

}
