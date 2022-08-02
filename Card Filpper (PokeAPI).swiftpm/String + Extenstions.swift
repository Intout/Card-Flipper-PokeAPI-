//
//  String + Extenstions.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 1.08.2022.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
