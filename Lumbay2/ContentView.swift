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

struct WorldView: View {
    
    var body: some View {
        VStack {
            Text("Hi, World!")
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
            Text(gameCode.wrappedValue)
            if !gameCodeStatus.isEmpty {
                Text(gameCodeStatus)
            }
            Text(gameStatusText)
            Button(action: {
                Task {
                    do {
                        try await client.generateGameCode()
                    } catch {
                        gameCodeStatus = error.localizedDescription
                    }
                }
            }) {
                Text("Generate Game Code")
            }
            Button(
                action: {
                    print("TODO: will start game")
                },
                label: {
                    Text("Start Game")
                }
            )
            .disabled(gameStatus.wrappedValue != .readyToStart)
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
            Button(action: {
                print("TODO: will join game via QR code")
            }) {
                Text("Join Game via QR Code")
            }
            TextField("Enter Game Code", text: $gameCode)
                .multilineTextAlignment(.center)
            Button(action: {
                print("TODO: will join game via game code = \(gameCode)")
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
