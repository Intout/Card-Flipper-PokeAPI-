//
//  ContentView + ViewModel.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 31.07.2022.
//

import Foundation

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        
        @Published private(set) var firstCardData: CardData?
        private var pokemonCount: Int?
        
        private var dataModel = DataModel()
         
        func viewDidLoad(){
            dataModel.fetchAPIdata(){ [unowned self] error, data in
                print(data)
            }
        }
        
        
        
    }
}
