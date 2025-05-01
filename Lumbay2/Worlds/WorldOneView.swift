import SwiftUI
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.world) var world: Binding<Lumbay2sv_World?>
    
    var body: some View {
        VStack {
            Text("Hi, World One!")
            Button(action: { print("TODO: will exit game") }) {
                Text("Exit Game")
            }
        }
    }
}
