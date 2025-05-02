import SwiftUI
import SpriteKit
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.world) var world: Binding<Lumbay2sv_World?>
    
    @State private var scene: SKScene

    init() {
        scene = GameScene2(size: UIScreen.main.bounds.size)
        scene.size = UIScreen.main.bounds.size
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func worldView(world: Lumbay2sv_World) -> some View {
        Text("Hello \(world.name)")
    }
}
