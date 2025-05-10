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

enum InitialDataProcess {
    case none, started, ended
}
