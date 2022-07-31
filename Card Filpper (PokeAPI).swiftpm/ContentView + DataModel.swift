//
//  ContentView + DataModel.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 31.07.2022.
//

import Foundation

extension ContentView{
    
    enum DataModelError: Error{
        case invalidData
    }
    
    class DataModel{
        
        func fetchAPIdata(completionHandler: @escaping (Error?, Int?) -> ()){
            
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
                completionHandler(URLError(.badURL), nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){ data, response, error in
               
                guard let data = data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                    completionHandler(error, nil)
                    print("Couldn't fetch API data!")
                    return
                }
                
                let jsonData = try? JSONDecoder().decode(PokeAPIData.self, from: data)
                
                if let jsonData = jsonData{
                    completionHandler(nil, jsonData.count)
                    return
                } else {
                    completionHandler(DataModelError.invalidData, nil)
                    return
                }
            }.resume()
        }
        
        func fetchPokemonData(for id: Int, completionHandler: @escaping (Error?, PokemonData?) -> Int){
            
        }
        
    }
}
