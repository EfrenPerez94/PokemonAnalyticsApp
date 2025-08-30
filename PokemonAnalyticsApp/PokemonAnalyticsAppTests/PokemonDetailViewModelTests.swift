//
//  PokemonDetailViewModelTests.swift
//  PokemonAnalyticsAppTests
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import XCTest
import SwiftData
@testable import PokemonAnalyticsApp

private struct MockAPI: PokeAPI {
    
    func list(offset: Int, limit: Int) async throws -> PokemonsListModel {
        .init(count: 0, next: nil, previous: nil, results: [])
    }
    
    func pokemon(id: Int) async throws -> PokemonDetailModel {
        .init(
            id: 1, name: "charmander", height: 1, weight: 1,
            sprites: .init(frontShiny: nil),
            types: [.init(slot: 1, type: PokemonItemModel(name: "fire", url: ""))],
            stats: [
                .init(baseStat: 10, effort: 0, stat: .init(name: "hp", url: "")),
                .init(baseStat: 10, effort: 0, stat: .init(name: "attack", url: "")),
                .init(baseStat: 10, effort: 0, stat: .init(name: "defense", url: "")),
                .init(baseStat: 10, effort: 0, stat: .init(name: "special-attack", url: "")),
                .init(baseStat: 10, effort: 0, stat: .init(name: "special-defense", url: "")),
                .init(baseStat: 10, effort: 0, stat: .init(name: "speed", url: "")),
            ],
            abilities: []
        )
    }
}

@MainActor
final class PokemonDetailViewModelTests: XCTestCase {
    
    var viewModel: PokemonDetailViewModel!

    override func setUpWithError() throws {
        let container = try ModelContainer(
            for: FavoritePokemon.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        let mock = MockAPI()
        viewModel = PokemonDetailViewModel(id: 1, api: mock, context: context)
    }
    
    func testLoad() async throws {
        await viewModel.load()
        guard case .loaded(let pokemon) = viewModel.state else { return XCTFail("Expected .loaded") }
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(viewModel.chartData.count, 6)
        XCTAssertEqual(viewModel.totalBaseStat, 10*6)
    }
    
    
    func testFavorite() async throws {
        await viewModel.load()
        try viewModel.toggleFavorite();  XCTAssertTrue(viewModel.isFavorite)
        try viewModel.toggleFavorite();  XCTAssertFalse(viewModel.isFavorite)
    }
}
