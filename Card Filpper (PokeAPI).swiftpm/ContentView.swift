import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State var frontDegree: CGFloat = 0.01
    @State var backDegree: CGFloat = 89.99
    @State private var flipCount: Int = 0
    
    @State private var fronImage: AsyncImage<Image>?
    @State private var backImage: AsyncImage<Image>?
    
    @State private var backgroundColor: Color = .clear
    
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
                    CardView(cardData: $viewModel.frontData, degree: $frontDegree, image: $fronImage, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                        .onReceive(viewModel.$frontData){ data in
                            if let url = URL(string: data?.iconURL ?? ""){
                                fronImage = AsyncImage(url: url)
                            }
                        }
                    CardView(cardData: $viewModel.backData, degree: $backDegree, image: $backImage, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                        .onReceive(viewModel.$backData){ data in
                            if let url = URL(string: data?.iconURL ?? ""){
                                backImage = AsyncImage(url: url)
                            }
                        }
                }
                    .onTapGesture {
                        flipCardAction()
                        flipCount += 1
                    }
                Spacer()
            }
            .onAppear{
                viewModel.viewDidLoad()
            }
            
            .background{
                backgroundColor
                    .ignoresSafeArea(.container)
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
    
    func setBothImage(){
        
        if let url = URL(string: viewModel.frontData!.iconURL){
            fronImage = AsyncImage(url: url)
        }
        
        if let url = URL(string: viewModel.backData!.iconURL){
            backImage = AsyncImage(url: url)
        }
        
    }
    
}
