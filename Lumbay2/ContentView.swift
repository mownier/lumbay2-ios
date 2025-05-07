import SwiftUI
import Lumbay2cl

struct ContentView: View {
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
    @Environment(\.initialDataStatus) var initialDataStatus: Binding<Lumbay2sv_InitialDataStatus>
    @Environment(\.initialDataProcess) var initialDataProcess: Binding<InitialDataProcess>
    
    var body: some View {
        ZStack {
            contentView()
                .opacity(clientOkay.wrappedValue ? 1 : 0)
            ConnectView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
                .opacity(clientOkay.wrappedValue ? 0 : 1)
        }
    }
    
    @ViewBuilder private func contentView() -> some View {
        switch initialDataStatus.wrappedValue {
        case .ended:
            initialDataStatusEnded()
        case .started:
            initialDataStatusStarted()
        case .none:
            Text("Preparing initial data...")
        case .UNRECOGNIZED(let rawValue):
            Text("Preparing (\(rawValue)) initial data...")
        }
    }
    
    @ViewBuilder private func initialDataStatusStarted() -> some View {
        Text("Getting initial data...")
    }
    
    @ViewBuilder private func initialDataStatusEnded() -> some View {
        switch initialDataProcess.wrappedValue {
        case .ended:
            initialDataProcessEnded()
        case .started:
            initialDataProcessStarted()
        case .none:
            Text("Preparing initial data process...")
        }
    }
    
    @ViewBuilder private func initialDataProcessStarted() -> some View {
        Text("Processing initial data...")
    }
    
    @ViewBuilder private func initialDataProcessEnded() -> some View {
        switch gameStatus.wrappedValue {
        case .none:
            WelcomeView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.orange)
        case .waitingForOtherPlayer, .readyToStart:
            GamePreparationView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.pink)
        case .started:
            WorldView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.brown)
        default:
            Text("Game status unknown: \(gameStatus.wrappedValue)")
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

enum InitialDataProcess {
    case none, started, ended
}
