//
//  FavoritePokemonTests.swift
//  PokemonAnalyticsAppUITests
//
//  Created by Efrén Pérez Bernabe on 28/08/25.
//

import XCTest
@testable import PokemonAnalyticsApp
import SwiftData

@MainActor
final class FavoritePokemonTests: XCTestCase {
    
    var container: ModelContainer!
    var context: ModelContext!

    override func setUpWithError() throws {
        let cfg = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: FavoritePokemon.self, configurations: cfg)
        context = ModelContext(container)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertAndFetchFavorite() throws {
        context.insert(FavoritePokemon(id: 25, name: "pikachu", url: ""))
        try context.save()
        let fd = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == 25 })
        let results = try context.fetch(fd)
        XCTAssertEqual(results.first?.name, "pikachu")
    }

    func testDeleteFavorite() throws {
        let fav = FavoritePokemon(id: 1, name: "charmander", url: "")
        context.insert(fav)
        try context.save()
        context.delete(fav)
        try context.save()
        let all = try context.fetch(FetchDescriptor<FavoritePokemon>())
        XCTAssertTrue(all.isEmpty)
    }
}
