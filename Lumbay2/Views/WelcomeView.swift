import SwiftUI
import Lumbay2cl

struct WelcomeView: View {
    @Environment(\.client) var client: Lumbay2Client
    
    @State var gameCode: String = ""
    @State var status: String = ""
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    let maxButtonWidth: CGFloat = 200

    var body: some View {
        VStack {
            Text(status)
            newGameButton()
            gameCodeTextField()
            joinGameButton()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder private func gameCodeTextField() -> some View {
        TextField("Enter Code", text: $gameCode)
            .modifier(TextFieldWithStretchableBkg(style: "1", width: maxButtonWidth))
    }
    
    @ViewBuilder private func joinGameButton() -> some View {
        Button("Join Game") {
            Task {
                do {
                    try await client.joinGame(gameCode: gameCode)
                } catch {
                    showError = true
                    errorMessage = "Unable to join game. Please try again."
                }
            }
        }
        .modifier(ButtonWithStretchableBkg(style: "2", width: maxButtonWidth))
        
    }
    
    @ViewBuilder private func newGameButton(_ fixed: Bool = false) -> some View {
        Button("New Game") {
            Task {
                do {
                    try await client.createGame()
                } catch {
                    showError = true
                    errorMessage = "Unable to create game. Please try again."
                }
            }
        }
        .modifier(ButtonWithStretchableBkg(style: "1", width: maxButtonWidth))
    }
}
