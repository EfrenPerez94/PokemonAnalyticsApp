# PokemonAnalyticsApp
iOS Pokémon code challenge — Pokédex &amp; analytics using PokeAPI

## Goals
- List + search Pokémon, detail, favorites.
- Network error simulation with retry.
- Cache/persistence + offline-first feel.

## Architecture
MVVM + Coordinator (UIKit nav) with SwiftUI views via UIHostingController.  
Combine for UI events; async/await for networking. RequestState: idle/fetching/loaded/failed.
