import SwiftUI
import Lumbay2cl

struct ConnectView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.subscribeTask) var subscribeTask: Binding<Task<Void, Error>?>
    
    @State var showError: Bool = false
    
    let maxButtonWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            if clientOkay.wrappedValue {
                disconnectButton()
            } else {
                connectButton()
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text("Unable to connect. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder func connectButton() -> some View {
        Button("Connect") {
            Task {
                do {
                    let task = try await client.prepareAndSubscribe()
                    clientOkay.wrappedValue = true
                    subscribeTask.wrappedValue = task
                    switch await task.result {
                    case .failure(let error):
                        throw error
                    default:
                        break
                    }
                } catch {
                    clientOkay.wrappedValue = false
                    showError = true
                }
            }
        }
        .modifier(ButtonWithStretchableBkg(style: "4", width: maxButtonWidth))
    }
    
    @ViewBuilder func disconnectButton() -> some View {
        Button("Disconnect") {
            subscribeTask.wrappedValue?.cancel()
            subscribeTask.wrappedValue = nil
        }
        .modifier(ButtonWithStretchableBkg(style: "3", width: maxButtonWidth))
    }
}
