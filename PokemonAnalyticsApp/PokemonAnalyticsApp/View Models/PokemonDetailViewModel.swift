//
//  PokemonDetailViewModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation
import SwiftData

@MainActor
final class PokemonDetailViewModel: ObservableObject {

    @Published private(set) var state: RequestState<PokemonDetailModel> = .idle
    @Published private(set) var isFavorite: Bool = false
    @Published var favoriteError: AppError?

    let pokemonId: Int
    private let api: PokeAPI
    private let context: ModelContext
    
    init(id: Int, api: PokeAPI, context: ModelContext) {
        self.pokemonId = id
        self.api = api
        self.context = context
    }

    func load() async {
        guard case .idle = state else { return }
        state = .fetching
        await fetch()
    }

    func retry() async {
        await fetch()
    }

    func toggleFavorite() throws {
        do {
            let pokemon = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == pokemonId })
            if let current = try context.fetch(pokemon).first {
                context.delete(current)
                isFavorite = false
            } else {
                if let name = try currentPokemon()?.name {
                    context.insert(FavoritePokemon(id: pokemonId, name: name))
                    isFavorite = true
                }
            }
            try context.save()
        } catch {
            let appError: AppError = .persistence(error.localizedDescription)
            favoriteError = appError
            throw appError
        }
    }

    struct StatData: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let value: Int
    }

    /// Chart data from the loaded Pokémon (hp/atk/def/sp.atk/sp.def/speed)
    var chartData: [StatData] {
        guard case .loaded(let pokemon) = state else { return [] }
        let order = ["hp", "attack", "defense", "special-attack", "special-defense", "speed"]
        let dict = Dictionary(uniqueKeysWithValues: pokemon.stats.map { ($0.stat.name, $0.baseStat) })
        return order.compactMap { key in
            dict[key].map {
                StatData(label: key.replacingOccurrences(of: "-", with: " ").uppercased(), value: $0)
            }
        }
    }
    
    struct DonutSection: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let value: Int
    }

    /// Sum of base stats (hp + attack + defense + sp.atk + sp.def + speed).
    var totalBaseStat: Int {
        guard case .loaded(let pokemon) = state else { return 0 }
        return pokemon.stats.reduce(0) { $0 + $1.baseStat }
    }

    /// Donut segments: filled vs remaining up to `maxTotalBaseStat`.
    var donutData: [DonutSection] {
        guard case .loaded = state else { return [] }
        let filled = totalBaseStat
        let remaining = 720 - filled
        return [
            DonutSection(label: "Total", value: filled),
            DonutSection(label: "Remaining", value: remaining)
        ]
    }

    // MARK: - Internals

    private func fetch() async {
        do {
            let pokemon = try await api.pokemon(id: pokemonId)
            state = .loaded(pokemon)
            isFavorite = try isFavorited()
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.other(error.localizedDescription))
        }
    }

    private func isFavorited() throws -> Bool {
        let pokemon = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == pokemonId })
        return try !context.fetch(pokemon).isEmpty
    }

    private func currentPokemon() throws -> PokemonDetailModel? {
        if case .loaded(let pokemon) = state {
            return pokemon
        }
        return nil
    }
}
