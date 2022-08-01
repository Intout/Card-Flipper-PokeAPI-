import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State var frontDegree: CGFloat = 0.01
    @State var backDegree: CGFloat = 89.99
    @State private var flipCount: Int = 0
    
    @State private var fronImage: Image?
    @State private var backImage: Image?
    
    @State private var frontColorAvarage: Color?
    @State private var backColorAvarage: Color?
    @State private var backgroundColor: Color = .purple
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack {
                HStack{
                    Button(action: {viewModel.viewDidLoad()}){
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(self.backgroundColor)
                                .padding([.all], 10)
                                
                        }
                    }
                    .disabled(viewModel.frontData == nil)
                    .frame(width: 48, height: 48)
                    Spacer()
                }
                .padding([.leading, .trailing], 16)
                Spacer()
                ZStack{
                    CardView(cardData: $viewModel.frontData, degree: $frontDegree, image: $fronImage, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                
                        .onReceive(viewModel.$frontImageData){ data in
                            if let data = data{
                                var uiImage = UIImage(data: data)!
                                fronImage = Image(uiImage: uiImage)
                                withAnimation(.linear(duration: viewModel.delay)){
                                    backgroundColor = Color( uiImage.averageColor ?? .clear)
                                }
                            }
                        }
                    CardView(cardData: $viewModel.backData, degree: $backDegree, image: $backImage, flipCount: $flipCount)
                        .frame(width: 3 * geometry.size.width/4, height: 2 * geometry.size.height/3)
                        .onReceive(viewModel.$backImageData){ data in
                            if let data = data{
                                var uiImage = UIImage(data: data)!
                                backImage = Image(uiImage: uiImage)
                                withAnimation(.linear(duration: viewModel.delay)){
                                    backgroundColor = Color( uiImage.averageColor ?? .clear)
                                }
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
            fronImage = nil
            withAnimation(.linear(duration: viewModel.delay)){
                backDegree = 89.99
            }
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
                frontDegree = 0.01
            }
            
            
        } else {
            backImage = nil
            withAnimation(.linear(duration: viewModel.delay)){
                frontDegree = -89.99
            }
            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
                backDegree = 0.01
            }
        }
    }    
}
