import SwiftUI

struct WorldView: View {
    @Environment(\.worldName) var worldName: Binding<String>
    
    var body: some View {
        VStack {
            selectedWorldView()
        }
    }
    
    @ViewBuilder
    private func selectedWorldView() -> some View {
        switch worldName.wrappedValue {
        case "World 1":
            WorldOneView()
        default:
            Text("Unknown world")
        }
    }
}
