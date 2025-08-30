//
//  PokedexListViewCoordinator.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import UIKit
import SwiftUI
import SwiftData

@MainActor
final class PokedexListViewCoordinator {
    private let navigationController: UINavigationController
    private let api: PokeAPI
    private let modelContainer: ModelContainer

    init(navigationController: UINavigationController, api: PokeAPI, modelContainer: ModelContainer) {
        self.navigationController = navigationController
        self.api = api
        self.modelContainer = modelContainer
    }

    func start() {
        let view = PokedexListView(viewModel: PokedexListViewModel(api: self.api)) { [weak self] item in
            guard let weakSelf = self else { return }
            weakSelf.showDetail(for: item)
        }
        let viewController = UIHostingController(rootView: view.modelContainer(modelContainer))
        viewController.title = "Pokédex"
        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showDetail(for pokemon: PokemonItemModel) {
        guard let id = pokemon.id else { return }
        let viewModel = PokemonDetailViewModel(id: id, api: self.api, context: ModelContext(self.modelContainer))
        let detail = PokemonDetailView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: detail.modelContainer(modelContainer))
        navigationController.pushViewController(viewController, animated: true)
    }
}
