import SwiftUI
import Lumbay2cl

struct GamePreparationView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.gameCode) var gameCode: Binding<String>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    let maxButtonWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            gameCodeText()
            Text(gameStatusText)
                .modifier(TextWithCustomFont(fontSize: 18))
            generateCodeButton()
            startGameButton()
            quitGameButton()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder private func gameCodeText() -> some View {
        if gameStatus.wrappedValue != .readyToStart {
            Text(gameCode.wrappedValue)
                .modifier(TextWithCustomFont(fontSize: 64))
                .task {
                    await generateGameCode()
                }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func generateCodeButton() -> some View {
        if gameStatus.wrappedValue != .readyToStart {
            Button("Generate Code") {
                Task { await generateGameCode() }
            }
            .modifier(ButtonWithStretchableBkg(style: "1", width: maxButtonWidth))
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func startGameButton() -> some View {
        if gameStatus.wrappedValue == .readyToStart {
            Button("Start Game") {
                Task {
                    do {
                        try await client.startGame()
                    } catch {
                        showError = true
                        errorMessage = "Unable to start game. Please try again."
                    }
                }
            }
            .modifier(ButtonWithStretchableBkg(style: "4", width: maxButtonWidth))
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private func quitGameButton() -> some View {
        Button("Quit Game") {
            Task {
                do {
                    try await client.quitGame()
                } catch {
                    showError = true
                    errorMessage = "Unable to quit game. Please try again."
                }
            }
        }
        .modifier(ButtonWithStretchableBkg(style: "3", width: maxButtonWidth))
    }
    
    private func generateGameCode() async {
        do {
            try await client.generateGameCode()
        } catch {
            showError = true
            errorMessage = "Unable to generate code. Please try again"
        }
    }
    
    private var gameStatusText: String {
        let text: String
        switch gameStatus.wrappedValue {
        case .readyToStart: text = "Ready to start"
        case .waitingForOtherPlayer: text = "Waiting for other player"
        case .started: text = "Game started"
        default: text = ""
        }
        return text
    }
}

