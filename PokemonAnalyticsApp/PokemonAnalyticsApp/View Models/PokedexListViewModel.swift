//
//  PokedexListViewModel.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import Foundation
import Combine

@MainActor
final class PokedexListViewModel: ObservableObject {

    @Published private(set) var items: [PokemonItemModel] = []
    @Published private(set) var state: RequestState<[PokemonItemModel]> = .idle

    private var offset: Int = 0
    private let pageSize: Int = 30
    private var canLoadMore: Bool = true
    private var isLoading: Bool = false
    private let loadMore = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let api: PokeAPI

    init(api: PokeAPI) {
        self.api = api

        loadMore
            .compactMap { [weak self] in
                self?.offset
            }
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task { await self.loadNextPage() }
            }
            .store(in: &cancellables)
    }

    func loadFirstPage() async {
        guard items.isEmpty else { return }
        state = .fetching
        await loadNextPage()
    }

    func loadNextPage(_ pokemon: PokemonItemModel) {
        guard canLoadMore, !isLoading else { return }
        if let index = items.firstIndex(of: pokemon),
            index >= items.count - 5 {
                loadMore.send(())
            }
    }

    func retryLoad() async {
        guard case .failed = state else { return }
        await loadNextPage()
    }

    private func loadNextPage() async {
        guard canLoadMore, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let page = try await api.list(offset: offset, limit: pageSize)
            items.append(contentsOf: page.results)
            state = .loaded(items)
            offset += pageSize
            canLoadMore = (page.next != nil)
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.other(error.localizedDescription))
        }
    }
}
