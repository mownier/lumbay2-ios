import SwiftUI
import Lumbay2cl

struct WorldView: View {
    @Environment(\.worldID) var worldID: Binding<Lumbay2sv_WorldId>
    
    var body: some View {
        VStack {
            selectedWorldView()
        }
    }
    
    @ViewBuilder
    private func selectedWorldView() -> some View {
        switch worldID.wrappedValue {
        case Lumbay2sv_WorldId.one:
            WorldOneView()
        default:
            Text("Unknown world")
        }
    }
}
