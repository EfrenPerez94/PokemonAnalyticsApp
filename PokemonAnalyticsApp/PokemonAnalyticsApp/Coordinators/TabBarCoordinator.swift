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

    init(api: PokeAPI, modelContainer: ModelContainer) {
        self.api = api
        self.modelContainer = modelContainer
    }

    @MainActor
    func start(on tabBar: UITabBarController) {
        // Tab 1: Pokédex (paginated list)
        let pokedexNavigationController = UINavigationController()
        let pokedex = PokedexListViewCoordinator(
            navigationController: pokedexNavigationController,
            api: api,
            modelContainer: modelContainer
        )
        pokedex.start()
        pokedexNavigationController.tabBarItem = UITabBarItem(title: "Pokédex",
                                                              image: UIImage(systemName: "list.bullet"),
                                                              selectedImage: nil)

        // Tab 2: Favorites (placeholder por ahora)
        let favNav = UINavigationController()
        let favVC = UIHostingController(rootView: Text("Favorites (coming soon)")
            .padding()
            .modelContainer(modelContainer))
        favVC.title = "Favorites"
        favNav.setViewControllers([favVC], animated: false)
        favNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: nil)

        // Tab 3: Insights (placeholder por ahora)
        let insightsNav = UINavigationController()
        let insightsVC = UIHostingController(rootView: Text("Insights (coming soon)")
            .padding()
            .modelContainer(modelContainer))
        insightsVC.title = "Insights"
        insightsNav.setViewControllers([insightsVC], animated: false)
        insightsNav.tabBarItem = UITabBarItem(title: "Insights",
                                              image: UIImage(systemName: "chart.bar"),
                                              selectedImage: nil)

        tabBar.viewControllers = [pokedexNavigationController, favNav, insightsNav]
    }
}
