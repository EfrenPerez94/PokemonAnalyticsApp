//
//  PokemonDetailView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 29/08/25.
//

import SwiftUI
import Charts
import SwiftData

struct PokemonDetailView: View {
    @StateObject var viewModel: PokemonDetailViewModel

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: tryToggleFavorite) {
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                    }
                    .accessibilityLabel(viewModel.isFavorite ? "Remove Favorite" : "Add to Favorites")
                }
            }
            .alert(
                "Favorites error",
                isPresented: Binding(
                    get: { viewModel.favoriteError != nil },
                    set: { if !$0 { viewModel.favoriteError = nil } }
                ),
                actions: { Button("OK", role: .cancel) {} },
                message: { Text(viewModel.favoriteError?.errorDescription ?? "Unknown error") }
            )
            .task { await viewModel.load() }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()

        case .fetching:
            if case .loaded(let pokemon) = viewModel.state {
                detailView(pokemon)
            } else {
                ProgressView()
            }

        case .failed(let err):
            VStack(spacing: 12) {
                Text(err.errorDescription ?? "Error").foregroundStyle(.red)
                Button("Retry") { Task { await viewModel.retry() } }
            }
            .padding()

        case .loaded(let pokemon):
            detailView(pokemon)
        }
    }

    // MARK: - Reusable detail section

    @ViewBuilder
    private func detailView(_ pokemon: PokemonDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                if let url = pokemon.spriteURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFit()
                        case .failure: Color.gray.opacity(0.2)
                        case .empty: ProgressView()
                        @unknown default: Color.gray.opacity(0.2)
                        }
                    }
                    .frame(height: 160)
                }

                VStack(spacing: 6) {
                    Text(pokemon.name.capitalized).font(.title2).fontWeight(.semibold)
                    Text("#\(pokemon.id) • \(pokemon.typeNames.joined(separator: ", ").capitalized)")
                        .font(.subheadline).foregroundStyle(.secondary)
                    Text(String(format: "Height %.1fm • Weight %.1fkg", pokemon.height, pokemon.weight))
                        .font(.footnote).foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Base Stat").font(.headline)

                    ZStack {
                        Chart(viewModel.donutData) { data in
                            SectorMark(
                                angle: .value("Value", data.value),
                                innerRadius: .ratio(0.65)
                            )
                            .foregroundStyle(by: .value("Part", data.label))
                        }
                        .frame(height: 200)

                        VStack(spacing: 4) {
                            Text("\(viewModel.totalBaseStat)")
                                .font(.title2).bold()
                                .monospacedDigit()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Total Base Stat \(viewModel.totalBaseStat) of 720")
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Base Stats").font(.headline)
                    Chart(viewModel.chartData) { data in
                        BarMark(
                            x: .value("Value", data.value),
                            y: .value("Stat", data.label)
                        )
                    }
                    .chartXAxisLabel("Value")
                    .frame(height: 220)
                }
            }
            .padding()
        }
    }

    // MARK: - Actions

    private func tryToggleFavorite() {
        do {
            try viewModel.toggleFavorite()
        } catch {
            print("::: error")
        }
    }
}
