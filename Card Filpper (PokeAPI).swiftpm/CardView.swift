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
    @Binding var image: Image?
    @Binding var flipCount: Int
    @Binding var cardOffset: CGFloat
    
    var body: some View {
        ZStack{
            
            // Overlay Rectangle for transparent borders.
            Rectangle()
                .foregroundColor(Color(uiColor: .white.withAlphaComponent(0.5)))
                .cornerRadius(58)
                .padding([.all], -8)
            
            // If cardData is not available, card displays loading state.
            if cardData == nil{
                Text("Loading...")
            } else {
                VStack{
                    HStack(alignment: .center){
                        Spacer()
                        Text("\(cardData!.name.uppercased())")
                        Spacer()
                    }
                    Spacer()
                    if let image = image{
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        ProgressView()
                    }
                    Spacer()
                    HStack(spacing: 0){
                        VStack{
                            Text("HP")
                                .font(.footnote)
                            Text("\(cardData!.health)")
                                .font(.title)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack{
                            Text("Attack")
                                .font(.footnote)
                            Text("\(cardData!.attack)")
                                .font(.title)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack{
                            Text("Defense")
                                .font(.footnote)
                            Text("\(cardData!.defense)")
                                .font(.title)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
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
        // Horizontal and vertical flip is switched according to flip count.
        .rotation3DEffect(Angle(degrees: degree), axis: (x: flipCount % 2 == 0 ? 1 : 0.1, y: flipCount % 2 == 0 ? 0.1 : -1, z: 0))
        .offset(x: 0, y: cardOffset)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardData: Binding<CardData?>.constant(.init(iconURL: "", name: "Title", health: 1, attack: 1, defense: 1)), degree: Binding<CGFloat>.constant(0), image: .constant(nil), flipCount: Binding<Int>.constant(0), cardOffset: .constant(0))
    }
}
