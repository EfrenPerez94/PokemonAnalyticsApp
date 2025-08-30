//
//  FavoritesListView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 30/08/25.
//

import SwiftUI
import Charts

struct FavoritesListView: View {
    @StateObject var viewModel: FavoritesViewModel
    let onPokemonSelect: (FavoritePokemon) -> Void

    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                VStack(spacing: 8) {
                    Text("No favorites yet").font(.headline)
                    Text("Add some from the Pokédex.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else {
                List {
                    ForEach(viewModel.items, id: \.id) { pokemon in
                        PokemonCellView(pokemon: PokemonItemModel(name: pokemon.name, url: pokemon.url))
                            .onTapGesture {
                                onPokemonSelect(pokemon)
                            }
                    }
                    .onDelete(perform: viewModel.remove)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .onAppear { viewModel.loadFavorites() }
        .alert(
            "Favorites error",
            isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            ),
            actions: { Button("OK", role: .cancel) {} },
            message: { Text(viewModel.error?.errorDescription ?? "Unknown error") }
        )
    }
}
