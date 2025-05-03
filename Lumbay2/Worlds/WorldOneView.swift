import SwiftUI
import SpriteKit
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.worldOneStatus) var status: Binding<Lumbay2sv_WorldOneStatus>
    @Environment(\.worldOneObject) var object: Binding<Lumbay2sv_WorldOneObject?>
    @Environment(\.worldOneAssignedStone) var assignedStone: Binding<WorldOneAssignedStone>
    
    var body: some View {
        SpriteView(scene: GameScene3(UIScreen.main.bounds.size, status, object, assignedStone))
            .ignoresSafeArea()
    }
}

enum WorldOneAssignedStone {
    case none
    case stone1
    case stone2
}
