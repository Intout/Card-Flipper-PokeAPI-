import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            
            HStack{
                Button("Reset"){
                    viewModel.viewDidLoad()
                }
                Spacer()
            }
            Spacer()
            Button("Flip Card"){
                viewModel.flipCard()
                viewModel.isFlipped.toggle()
            }
            Spacer()
        }
        .onAppear{
            viewModel.viewDidLoad()
        }
    }
}
