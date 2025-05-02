import SwiftUI
import Lumbay2cl

struct WorldView: View {
    @Environment(\.world) var world: Binding<Lumbay2sv_World>
    
    var body: some View {
        VStack {
            selectedWorldView()
        }
    }
    
    @ViewBuilder
    private func selectedWorldView() -> some View {
        switch world.id.wrappedValue {
        case Lumbay2sv_WorldId.worldOne:
            WorldOneView()
        default:
            Text("Unknown world")
        }
    }
}
