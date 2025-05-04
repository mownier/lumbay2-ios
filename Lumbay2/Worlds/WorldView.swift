import SwiftUI
import Lumbay2cl

struct WorldView: View {
    @Environment(\.worldID) var worldID: Binding<Lumbay2sv_WorldId>
    
    var body: some View {
        VStack {
            if worldID.wrappedValue == Lumbay2sv_WorldId.one {
                WorldOneView()
            } else {
                Text("Loading World...")
            }
        }
    }
}
