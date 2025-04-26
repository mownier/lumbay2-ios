import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ServiceListView(serviceBrowser: ServiceBrowser(serviceType: "_lumbay._tcp", domain: ""))
                    .navigationTitle("Discovered Services")
            }
        }
    }
}

struct ServiceListView: View {
    @ObservedObject var serviceBrowser: ServiceBrowser
    
    var body: some View {
        VStack {
            Text("\(serviceBrowser.serverInfo.hostName):\(serviceBrowser.serverInfo.port)")
        }
        .onAppear {
            serviceBrowser.startBrowsing()
        }
        .onDisappear {
            serviceBrowser.stopBrowsing()
        }
    }
}
