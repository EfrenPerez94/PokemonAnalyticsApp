//
//  FavoritesListViewCoordinator.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 30/08/25.
//

import UIKit
import SwiftUI
import SwiftData

@MainActor
final class FavoritesListViewCoordinator {
    private let navigationController: UINavigationController
    private let api: PokeAPI
    private let modelContainer: ModelContainer

    init(navigationController: UINavigationController, api: PokeAPI, modelContainer: ModelContainer) {
        self.navigationController = navigationController
        self.api = api
        self.modelContainer = modelContainer
    }

    func start() {
        let viewModel = FavoritesViewModel(context: ModelContext(modelContainer), api: self.api)
        let view = FavoritesListView(viewModel: viewModel) { [weak self] item in
            guard let weakSelf = self else { return }
            weakSelf.showDetail(for: item)
        }
        let viewController = UIHostingController(rootView: view.modelContainer(modelContainer))
        viewController.title = "Favorites"
        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showDetail(for item: FavoritePokemon) {
        let viewModel = PokemonDetailViewModel(id: item.id, api: self.api, context: ModelContext(self.modelContainer))
        let detail = PokemonDetailView(viewModel: viewModel).modelContainer(modelContainer)
        let viewController = UIHostingController(rootView: detail.modelContainer(modelContainer))
        navigationController.pushViewController(viewController, animated: true)
    }

}
