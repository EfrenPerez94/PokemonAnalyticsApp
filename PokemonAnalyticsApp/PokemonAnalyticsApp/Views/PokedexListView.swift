//
//  PokemonListView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import SwiftUI

struct PokedexListView: View {
    @StateObject var viewModel: PokedexListViewModel
    let onPokemonSelect: (PokemonItemModel) -> Void

    var body: some View {
        List {
            ForEach(viewModel.filteredPokemons, id: \.id) { pokemon in
                PokemonCellView(pokemon: pokemon)
                .onTapGesture { onPokemonSelect(pokemon) }
                .onAppear {
                    viewModel.loadNextPage(pokemon)
                }
            }
            // Loading footer
            if case .fetching = viewModel.state {
                HStack {
                    Spacer()
                    ProgressView().padding(.vertical, 12)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search name or #id")
        .listStyle(.plain)
        .task {
            await viewModel.loadFirstPage()
        }
        .overlay(alignment: .center) {
            if case .failed(let error) = viewModel.state {
                VStack(spacing: 8) {
                    Text(error.errorDescription ?? "Error")
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task { await viewModel.loadFirstPage() }
                    }
                }
                .padding()
            } else if viewModel.items.isEmpty, case .fetching = viewModel.state {
                ProgressView()
            }
        }
    }
}
