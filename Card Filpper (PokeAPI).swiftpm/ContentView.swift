import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Button("Flip Card"){
                viewModel.flipCard()
                viewModel.isFlipped.toggle()
            }
        }
        .onAppear{
            viewModel.viewDidLoad()
        }
    }
}
