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

    override func setUp() {
        super.setUp()
        let cfg = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: FavoritePokemon.self, configurations: cfg)
        context = ModelContext(container)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertAndFetchFavorite() throws {
        context.insert(FavoritePokemon(id: 25, name: "pikachu"))
        try context.save()
        let fd = FetchDescriptor<FavoritePokemon>(predicate: #Predicate { $0.id == 25 })
        let results = try context.fetch(fd)
        XCTAssertEqual(results.first?.name, "pikachu")
    }

    func testDeleteFavorite() throws {
        let fav = FavoritePokemon(id: 1, name: "charmander")
        context.insert(fav)
        try context.save()
        context.delete(fav)
        try context.save()
        let all = try context.fetch(FetchDescriptor<FavoritePokemon>())
        XCTAssertTrue(all.isEmpty)
    }
}
