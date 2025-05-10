import SwiftUI
import Lumbay2cl

struct ContentView: View {
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
    @Environment(\.initialDataStatus) var initialDataStatus: Binding<Lumbay2sv_InitialDataStatus>
    @Environment(\.initialDataProcess) var initialDataProcess: Binding<InitialDataProcess>
    
    var body: some View {
        ZStack {
            if clientOkay.wrappedValue {
                contentView()
            } else {
                ConnectView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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
            initialDataStatusNone()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder private func initialDataStatusNone() -> some View {
        Text("Preparing initial data...")
            .modifier(TextWithCustomFont(fontSize: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func initialDataStatusStarted() -> some View {
        Text("Getting initial data...")
            .modifier(TextWithCustomFont(fontSize: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func initialDataStatusEnded() -> some View {
        switch initialDataProcess.wrappedValue {
        case .ended:
            initialDataProcessEnded()
        case .started:
            initialDataProcessStarted()
        case .none:
            initialDataProcessNone()
        }
    }
    
    @ViewBuilder private func initialDataProcessNone() -> some View {
        Text("Preparing initial data process...")
            .modifier(TextWithCustomFont(fontSize: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func initialDataProcessStarted() -> some View {
        Text("Processing initial data...")
            .modifier(TextWithCustomFont(fontSize: 14))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            EmptyView()
        }
    }
}

enum InitialDataProcess {
    case none, started, ended
}
