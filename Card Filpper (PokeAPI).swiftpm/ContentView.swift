import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State var frontDegree: CGFloat = 0.01
    @State var backDegree: CGFloat = 89.99
    @State private var flipCount: Int = 0
    
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
                ZStack{
                    CardView(cardData: $viewModel.frontData, degree: $frontDegree, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                    CardView(cardData: $viewModel.backData, degree: $backDegree, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                }
                    .onTapGesture {
                        flipCardAction()
                        flipCount += 1
                    }
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

private extension ContentView{
    func flipCardAction(){
        viewModel.flipCard()
        if viewModel.isFlipped{
            withAnimation(.linear(duration: viewModel.delay)){
                backDegree = 89.99
            }
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
                frontDegree = 0.01
            }
        } else {
            withAnimation(.linear(duration: viewModel.delay)){
                frontDegree = -89.99
            }
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
                backDegree = 0.01
            }
        }
    }
}
