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
                .opacity(clientOkay.wrappedValue ? 0 : 1)
        }
        .background {
            ZStack {
                Image("background_image_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .blur(radius: 5)
            }
            .padding(.bottom, 200)
            .ignoresSafeArea()
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
        case .waitingForOtherPlayer, .readyToStart:
            GamePreparationView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .started:
            WorldView()
        default:
            Text("Game status unknown: \(gameStatus.wrappedValue)")
        }
    }
}

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

struct TextFieldWithStretchableBkg: ViewModifier {
    let style: String
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(Font.custom("Silom", size: 18))
            .foregroundStyle(Color.white)
            .padding(EdgeInsets(top: 12, leading: 23, bottom: 16, trailing: 24))
            .background(
                Image("button_1_stretchable_bkg")
                    .resizable(capInsets: EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 20), resizingMode: .stretch)
                    .frame(width: width)
            )
            .tint(Color.white)
            .frame(width: width)
    }
}

struct ButtonWithStretchableBkg: ViewModifier {
    let style: String
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Silom", size: 18))
            .foregroundStyle(Color.white)
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 16, trailing: 24))
            .background(
                Image("button_\(style)_stretchable_bkg")
                    .resizable(capInsets: EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 20), resizingMode: .stretch)
                    .frame(width: width)
            )
            .frame(width: width)
    }
}

struct TextWithCustomFont: ViewModifier {
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Silom", size: fontSize))
            .foregroundStyle(Color("poopy_green").opacity(0.8))
    }
}
