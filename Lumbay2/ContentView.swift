import SwiftUI
import Lumbay2cl

struct ContentView: View {
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
    
    var body: some View {
        ZStack {
            switch gameStatus.wrappedValue {
            case .none:
                WelcomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.orange)
                    .opacity(clientOkay.wrappedValue ? 1 : 0)
            case .waitingForOtherPlayer, .readyToStart:
                GamePreparationView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.pink)
                    .opacity(clientOkay.wrappedValue ? 1 : 0)
            case .started:
                WorldView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.brown)
                    .opacity(clientOkay.wrappedValue ? 1 : 0)
            default:
                EmptyView()
            }
            ConnectView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
                .opacity(clientOkay.wrappedValue ? 0 : 1)
        }
    }
}

struct GamePreparationView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.gameCode) var gameCode: Binding<String>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
    
    @State var gameCodeStatus: String = ""
    
    var body: some View {
        VStack {
            if gameStatus.wrappedValue != .readyToStart {
                Text(gameCode.wrappedValue)
                    .task {
                        await generateGameCode()
                    }
            }
            if !gameCodeStatus.isEmpty {
                Text(gameCodeStatus)
            }
            Text(gameStatusText)
            if gameStatus.wrappedValue != .readyToStart {
                Button(action: { Task { await generateGameCode() }}) {
                    Text("Generate Game Code")
                }
            }
            Button(
                action: {
                    Task {
                        do {
                            try await client.startGame()
                        } catch {
                            gameCodeStatus = error.localizedDescription
                        }
                    }
                },
                label: {
                    Text("Start Game")
                }
            )
            .disabled(gameStatus.wrappedValue != .readyToStart)
            Button(
                action: {
                    Task {
                        do {
                            try await client.quitGame()
                        } catch {
                            gameCodeStatus = error.localizedDescription
                        }
                    }
                },
                label: {
                    Text("Quit Game")
                }
            )
        }
    }
    
    private func generateGameCode() async {
        do {
            try await client.generateGameCode()
        } catch {
            gameCodeStatus = error.localizedDescription
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

struct WelcomeView: View {
    @Environment(\.client) var client: Lumbay2Client
    
    @State var gameCode: String = ""
    @State var status: String = ""
    
    var body: some View {
        VStack {
            Text(status)
            Button(action: {
                Task {
                    do {
                        try await client.createGame()
                    } catch {
                        status = error.localizedDescription
                    }
                }
            }) {
                Text("New Game")
            }
            TextField("Enter Game Code", text: $gameCode)
                .multilineTextAlignment(.center)
            Button(action: {
                Task {
                    do {
                        try await client.joinGame(gameCode: gameCode)
                    } catch {
                        status = error.localizedDescription
                    }
                }
            }) {
                Text("Join Game")
            }
        }
    }
}

struct ConnectView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.subscribeTask) var subscribeTask: Binding<Task<Void, Error>?>
    
    var body: some View {
        VStack {
            Button(
                action: {
                    if clientOkay.wrappedValue {
                        subscribeTask.wrappedValue?.cancel()
                        subscribeTask.wrappedValue = nil
                        return
                    }
                    Task {
                        await client.prepareAndSubscribe(clientOkay, subscribeTask)
                    }
                },
                label: {
                    Text(clientOkay.wrappedValue ? "Disconnect" : "Connect")
                }
            )
        }
    }
}
