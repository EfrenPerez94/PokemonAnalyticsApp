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
            ForEach(viewModel.items, id: \.id) { pokemon in
                HStack(spacing: 12) {
                    AsyncImage(url: pokemon.imageURL) { phase in
                        switch phase {
                        case .success(let sprite):
                            sprite
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            //poner imagen default
                            Color.gray.opacity(0.2)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            //poner imagen default
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))

                    Text(pokemon.name)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { onPokemonSelect(pokemon) }
                .onAppear {
                    viewModel.loadNextPage(pokemon) }
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
