import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State var frontDegree: CGFloat = 0.01
    @State var backDegree: CGFloat = 89.99
    @State var cardOffset: CGFloat = 0
    @State private var flipCount: Int = 0
    
    @State private var frontImage: Image?
    @State private var backImage: Image?
    
    @State private var frontColorAvarage: Color?
    @State private var backColorAvarage: Color?
    @State private var backgroundColor: Color = .purple
    
    @State private var animationLock: Bool = false
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack {
                HStack{
                    Button(action:
                            {
                        
                        if viewModel.isFlipped{
                            frontImage = nil
                            withAnimation(.linear(duration: viewModel.delay)){
                                backDegree = 89.99
                            }
                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
                                frontDegree = 0.01
                            }
                            viewModel.isFlipped.toggle()
                        }
                        cardResetAction(displayWith: geometry.size.height)
                    }){
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
                    // If data is not still fetched from API, reset button will be disabled until data available.
                    .disabled(viewModel.frontData == nil)
                    .frame(width: 48, height: 48)
                    Spacer()
                }
                .padding([.leading, .trailing], 16)
                Spacer()
                ZStack{
                    CardView(cardData: $viewModel.frontData, degree: $frontDegree, image: $frontImage, flipCount: $flipCount, cardOffset: $cardOffset)
                    // Maximum width and height setted for iPad.
                        .frame(
                            maxWidth: sizeClass == .compact ? 400 : 600, maxHeight: sizeClass == .compact ? 600 : 400
                        )
                    
                    // Aspect ratio is preserved depending on compact or regular horizontal size.
                        .frame(
                            width: sizeClass == .compact ? 3 * geometry.size.width/4 : 2 * geometry.size.width/3,
                            height: sizeClass == .compact ? 2 * geometry.size.height/3 : 3 * geometry.size.height/4
                        )
                        
                        // If image data fetched, it published to onrecive function thus data is converted to uıimage and SwiftUI image.
                        .onReceive(viewModel.$frontImageData){ data in
                            if let data = data{
                                // UIImage used to accessing CIImage data and applying CIFilter to find average color of picture.
                                let uiImage = UIImage(data: data)!
                                frontImage = Image(uiImage: uiImage)
                                withAnimation(.linear(duration: viewModel.delay)){
                                    backgroundColor = Color( uiImage.averageColor ?? .clear)
                                }
                            }
                        }
                    CardView(cardData: $viewModel.backData, degree: $backDegree, image: $backImage, flipCount: $flipCount, cardOffset: $cardOffset)
                        .frame(
                            maxWidth: sizeClass == .compact ? 400 : 600, maxHeight: sizeClass == .compact ? 600 : 400
                        )
                        .frame(
                            width: sizeClass == .compact ? 3 * geometry.size.width/4 : 2 * geometry.size.width/3,
                            height: sizeClass == .compact ? 2 * geometry.size.height/3 : 3 * geometry.size.height/4
                        )
                        .onReceive(viewModel.$backImageData){ data in
                            if let data = data{
                                let uiImage = UIImage(data: data)!
                                backImage = Image(uiImage: uiImage)
                                withAnimation(.linear(duration: viewModel.delay)){
                                    backgroundColor = Color( uiImage.averageColor ?? .clear)
                                }
                            }
                        }
                }
                    .onTapGesture {
                        // Don't take input till animation is finished.
                        if !animationLock{
                            flipCardAction()
                            // Flip count is saved to memory to switching between horizontal and vertical flip.
                            flipCount += 1
                        }
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
        animationLock.toggle()
        viewModel.flipCard()
        if viewModel.isFlipped{
            frontImage = nil
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
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.delay * 2){
            animationLock.toggle()
        }
    }
    
    func cardResetAction(displayWith: CGFloat){
        animationLock.toggle()
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)){
            cardOffset = displayWith
        }
        viewModel.viewDidLoad()
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10).delay(viewModel.delay)){
            cardOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.delay * 2){
            animationLock.toggle()
        }
    }
}
