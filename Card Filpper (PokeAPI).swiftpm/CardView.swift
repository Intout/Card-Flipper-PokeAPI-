//
//  CardView.swift
//  Card Filpper (PokeAPI)
//
//  Created by Mert Tecimen on 31.07.2022.
//

import SwiftUI

protocol Flipable{
    var degree: CGFloat { get }
}

struct CardView: View, Flipable {
    
    @Binding var cardData: CardData?
    @Binding var degree: CGFloat
    
    var body: some View {
        VStack{
            if cardData == nil{
                Text("Loading...")
            } else {
                VStack{
                    HStack{
                        Spacer()
                        Text("\(cardData!.name.uppercased())")
                        Spacer()
                    }
                    Spacer()
                    Image(systemName: "square.and.arrow.down.fill")
                        .scaledToFill()
                    Spacer()
                    HStack{
                        VStack{
                            Text("HP")
                            Text("\(cardData!.health)")
                        }
                        Spacer()
                        VStack{
                            Text("Attack")
                            Text("\(cardData!.attack)")
                        }
                        Spacer()
                        VStack{
                            Text("Defense")
                            Text("\(cardData!.defense)")
                        }
                    }
                }
                .padding([.leading, .trailing], 30)
                .padding([.top, .bottom], 30)
                .background{
                    Color.white
                }
                .cornerRadius(50)
            }
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardData: Binding<CardData?>.constant(.init(iconURL: "", name: "Title", health: 1, attack: 1, defense: 1)), degree: Binding<CGFloat>.constant(0))
    }
}