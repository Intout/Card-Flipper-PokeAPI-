//
//  ContentView + ViewModel.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 31.07.2022.
//

import Foundation

extension ContentView{
    @MainActor class ViewModel: ObservableObject{
        
        @Published var frontData: CardData?
        @Published var backData: CardData?
        @Published var frontImageData: Data?
        @Published var backImageData: Data?
        @Published var isFlipped: Bool = false
        let delay: Double = 0.5
        
        
        private var pageNum: Int = 0
        private var pokemonCollection: [Result] = []
        private var dataModel = DataModel()
        
        func viewDidLoad(){
            
            
            let semaphore = DispatchSemaphore(value: 0)
            
            // First Page of data will be fetched for firt time or on reload.
            self.pageNum = 0
            dataModel.fetchAPIdata(for: pageNum){ [unowned self] error, data in
                guard let data = data else {
                    print(error?.localizedDescription as Any)
                    semaphore.signal()
                    return
                }
                self.pokemonCollection = data.results
                semaphore.signal()
            }
            
            semaphore.wait()
            // This is the first state of the card data, so I am using direct indices to access data for both
            // cards.
            if !pokemonCollection.isEmpty{
                
                let dispatchGroup = DispatchGroup()
                
                dataModel.fetchPokemonData(for: pokemonCollection[0].url){ [unowned self] error, data in
                    dispatchGroup.enter()
                    guard let data = data else {
                        print(error?.localizedDescription as Any)
                        dispatchGroup.leave()
                        return
                    }
                    Task{
                        dispatchGroup.leave()
                        self.frontData = .init(
                            iconURL: data.sprites.frontDefault,
                            name: data.name,
                            health: data.stats.first{
                                $0.stat.name.lowercased() == "hp"
                            }?.baseStat ?? 0,
                            attack: data.stats.first{
                                $0.stat.name.lowercased() == "attack"
                            }?.baseStat ?? 0,
                            defense: data.stats.first{
                                $0.stat.name.lowercased() == "defense"
                            }?.baseStat ?? 0)
                        print(frontData as Any)
                        getImageData(from: data.sprites.frontDefault)
                        
                    }
                }
                
                dataModel.fetchPokemonData(for: pokemonCollection[1].url){ [unowned self] error, data in
                    dispatchGroup.enter()
                    guard let data = data else {
                        print(error?.localizedDescription as Any)
                        dispatchGroup.leave()
                        return
                    }
                    Task{
                        dispatchGroup.leave()
                        self.backData = .init(
                            iconURL: data.sprites.frontDefault,
                            name: data.name,
                            health: data.stats.first{
                                $0.stat.name.lowercased() == "hp"
                            }?.baseStat ?? 0,
                            attack: data.stats.first{
                                $0.stat.name.lowercased() == "attack"
                            }?.baseStat ?? 0,
                            defense: data.stats.first{
                                $0.stat.name.lowercased() == "defense"
                            }?.baseStat ?? 0)
                        print(backData as Any)
                    }
                }
                
                dispatchGroup.notify(queue: .main){
                    self.pokemonCollection.removeFirst()
                    self.pokemonCollection.removeFirst()
                }
            }
        }
        
        
        /// Logic for card flip. When card flip requested new data for next flip would be prepared.
        func flipCard(){
            // If no pokemon left in current page, itarates to next page.
            let semaphore = DispatchSemaphore(value: 0)
            if self.pokemonCollection.isEmpty {
                pageNum += 1
                dataModel.fetchAPIdata(for: pageNum){ [unowned self] error, data in
                    guard let data = data else {
                        print(error?.localizedDescription as Any)
                        semaphore.signal()
                        return
                    }
                    self.pokemonCollection = data.results
                    semaphore.signal()
                }
            } else {
                semaphore.signal()
            }
            
            // Fetching Pokemon data should wait before fetching new API Page data.
            semaphore.wait()
            self.dataModel.fetchPokemonData(for: pokemonCollection.first!.url){ [unowned self] error, data in
                guard let data = data else {
                    print(error?.localizedDescription as Any)
                    return
                }
                Task{
                    // Type Casting
                    let cardData: CardData = .init(
                        iconURL: data.sprites.frontDefault,
                        name: data.name,
                        health: data.stats.first{
                            $0.stat.name.lowercased() == "hp"
                        }?.baseStat ?? 0,
                        attack: data.stats.first{
                            $0.stat.name.lowercased() == "attack"
                        }?.baseStat ?? 0,
                        defense: data.stats.first{
                            $0.stat.name.lowercased() == "defense"
                        }?.baseStat ?? 0)
                    print(cardData as Any)
                    
                    // If card is flipped front data should be ready for next flip otherwise back data should be ready.
                    if isFlipped{
                        self.frontData = cardData
                    } else {
                        self.backData = cardData
                    }
                    getImageData(from: cardData.iconURL)
                    isFlipped.toggle()
                }
            }
            
            // Fetched pokemon should be deleted from page collection so new data can be accessable with ".first"
            pokemonCollection.removeFirst()
        }
        
        /// Fetches Pokemon image data from given link by corresponding to card state.
        /// - Parameter link: String for Pokemon image URL.
        func getImageData(from link: String){
            // Image fetched for given pokemon url.
            guard let url = URL(string: link) else { return }
            
            URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil
                else { return }
                Task{
                    if self.isFlipped {
                        self.backImageData = data
                    } else {
                        self.frontImageData = data
                    }
                }
                    
            }.resume()
        }
        
    }
}

