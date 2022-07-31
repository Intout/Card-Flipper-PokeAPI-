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
        
        func fetchAPIdata(for pageNum: Int, completionHandler: @escaping (Error?, PokeAPIData?) -> ()){
            
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=\(20*pageNum)&limit=20") else {
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
                    completionHandler(nil, jsonData)
                    return
                } else {
                    completionHandler(DataModelError.invalidData, nil)
                    return
                }
            }.resume()
        }
        
        func fetchPokemonData(for urlString: String, completionHandler: @escaping (Error?, PokemonData?) -> ()){
            guard let url = URL(string: urlString) else {
                completionHandler(URLError(.badURL), nil)
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){ data, response, error in
                
                guard let data = data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                    completionHandler(error, nil)
                    print("Couldn't fetch Pokemon data!")
                    return
                }
                
                let jsonData = try? JSONDecoder().decode(PokemonData.self, from: data)
                if let jsonData = jsonData{
                    completionHandler(nil, jsonData)
                    return
                } else {
                    completionHandler(DataModelError.invalidData, nil)
                    return
                }
            }.resume()
        }
        
    }
}
