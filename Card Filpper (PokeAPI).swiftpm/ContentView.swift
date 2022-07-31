import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State var frontDegree: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack {
                HStack{
                    Button("Reset"){
                        viewModel.viewDidLoad()
                    }
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                Spacer()
                CardView(cardData: $viewModel.frontData, degree: $frontDegree)
                    .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                Spacer()
            }
            
            .background{
                Color.cyan
                    .ignoresSafeArea(.container)
            }
            .onAppear{
                viewModel.viewDidLoad()
            }
        }
    }
}
