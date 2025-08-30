//
//  TabBarCoordinator.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import UIKit
import SwiftUI
import SwiftData

final class TabBarCoordinator {
    private let api: PokeAPI
    private let modelContainer: ModelContainer
    private var pokedexCoordinator: PokedexListViewCoordinator?
    private var favoritesCoordinator: FavoritesListViewCoordinator?
    
    init(api: PokeAPI, modelContainer: ModelContainer) {
        self.api = api
        self.modelContainer = modelContainer
    }

    @MainActor
    func start(on tabBar: UITabBarController) {
        let pokedexNavigationController = UINavigationController()
        let pokedexListViewCoordinator = PokedexListViewCoordinator(navigationController: pokedexNavigationController,
                                                                    api: api,
                                                                    modelContainer: modelContainer)
        pokedexListViewCoordinator.start()
        pokedexCoordinator = pokedexListViewCoordinator
        pokedexNavigationController.tabBarItem = UITabBarItem(title: "Pokédex",
                                                              image: UIImage(systemName: "list.bullet"),
                                                              selectedImage: nil)

        let favoritesNavigationController = UINavigationController()
        let favoritesListViewCoordinator = FavoritesListViewCoordinator(navigationController: favoritesNavigationController,
                                                                        api: api,
                                                                        modelContainer: modelContainer)
        favoritesListViewCoordinator.start()
        self.favoritesCoordinator = favoritesListViewCoordinator
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites",
                                                                 image: UIImage(systemName: "star"),
                                                                 selectedImage: nil)

        tabBar.viewControllers = [pokedexNavigationController, favoritesNavigationController]
        
    }
}
