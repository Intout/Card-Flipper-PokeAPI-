//
//  File.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 31.07.2022.
//

import Foundation

// MARK: - PokeAPIData
struct PokeAPIData: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}

