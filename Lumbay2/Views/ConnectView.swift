import SwiftUI
import Lumbay2cl

struct ConnectView: View {
    @Environment(\.client) var client: Lumbay2Client
    @Environment(\.clientOkay) var clientOkay: Binding<Bool>
    @Environment(\.subscribeTask) var subscribeTask: Binding<Task<Void, Error>?>
    @Environment(\.clientSettings) var clientSettings: Binding<ClientSettings>
    
    @State var showError: Bool = false
    @State var host: String = ""
    @State var port: String = ""
    
    let maxButtonWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            hostTextField()
            portTextField()
            connectButton()
        }
        .task {
            host = clientSettings.host.wrappedValue
            port = clientSettings.port.wrappedValue?.description ?? ""
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text("Unable to connect. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder private func hostTextField() -> some View {
        TextField("Enter host", text: $host)
            .modifier(TextFieldWithStretchableBkg(style: "1", width: maxButtonWidth))
    }
    
    @ViewBuilder private func portTextField() -> some View {
        TextField("Enter port", text: $port)
            .modifier(TextFieldWithStretchableBkg(style: "1", width: maxButtonWidth))
    }
    
    @ViewBuilder func connectButton() -> some View {
        Button("Connect") {
            Task {
                do {
                    let port: Int? = Int(port)
                    let task = try await client
                        .setHost(host)
                        .setPort(port)
                        .setUseTLS(port == nil ? true : false)
                        .prepareAndSubscribe()
                    clientSettings.wrappedValue = ClientSettings(host: host, port: port)
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
}
