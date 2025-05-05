import SwiftUI
import SpriteKit
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.worldOneStatus) var status: Binding<Lumbay2sv_WorldOneStatus>
    @Environment(\.worldOneObject) var object: Binding<Lumbay2sv_WorldOneObject?>
    @Environment(\.worldOneRegionID) var regionID: Binding<Lumbay2sv_WorldOneRegionId>
    @Environment(\.worldOneAssignedStone) var assignedStone: Binding<WorldOneAssignedStone>
    @Environment(\.gameOverMessage) var gameOverMessage: Binding<String>
    @Environment(\.client) var client: Lumbay2Client
    
    @State var gameScene: GameScene3
    
    init() {
        gameScene = GameScene3()
        gameScene.size = UIScreen.main.bounds.size
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            SpriteView(scene: gameScene)
                .onChange(of: status.wrappedValue) { _, newValue in
                    gameScene.updateWorldStatus(newValue)
                }
                .onChange(of: object.wrappedValue) { _, newValue in
                    gameScene.updateWorldObject(newValue ?? Lumbay2sv_WorldOneObject())
                }
                .onAppear {
                    gameScene.client = client
                    gameScene.worldRegionID = regionID.wrappedValue
                    gameScene.worldStatus = status.wrappedValue
                    gameScene.worldObject = object.wrappedValue ?? Lumbay2sv_WorldOneObject()
                    gameScene.assignedStone = assignedStone.wrappedValue
                }
            VStack {
                if gameOverMessage.wrappedValue.isEmpty {
                    if status.wrappedValue == .yourTurnToMove {
                        Text("Your turn")
                        Circle()
                            .foregroundStyle(Color(uiColor: gameScene.yourStoneColor))
                            .frame(width: 100, height: 100)
                    } else if status.wrappedValue == .waitForYourTurn {
                        Text("Wait for your turn")
                        Circle()
                            .foregroundStyle(Color(uiColor: gameScene.otherStoneColor))
                            .frame(width: 100, height: 100)
                    } else {
                        EmptyView()
                    }
                } else {
                    Text(gameOverMessage.wrappedValue)
                    Button(action: {
                        print("TODO: will restart")
                    }) {
                        Text("Restart")
                    }
                    Button(action: {
                        print("TODO: will exit")
                    }) {
                        Text("Exit")
                    }
                }
            }
            .padding(.trailing, 32)
            .padding(.top, 32)
           
        }
        .ignoresSafeArea()
    }
}

enum WorldOneAssignedStone {
    case none
    case stone1
    case stone2
}
