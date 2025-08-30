//
//  PokemonCellView.swift
//  PokemonAnalyticsApp
//
//  Created by Efrén Pérez Bernabe on 30/08/25.
//

import SwiftUI

struct PokemonCellView: View {
    let pokemon: PokemonItemModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: pokemon.imageURL) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFit()
                case .failure: Color.gray.opacity(0.2)
                case .empty: ProgressView()
                @unknown default: Color.gray.opacity(0.2)
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(pokemon.name.capitalized)
                .font(.body)

            Spacer()

            Text("# \(pokemon.id ?? 0)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
