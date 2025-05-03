import SwiftUI
import SpriteKit
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.worldOneRegionID) var worldRegionID: Binding<Lumbay2sv_WorldOneRegionId>
    
    @State private var scene: SKScene

    init() {
        scene = GameScene3()
        scene.size = UIScreen.main.bounds.size
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
