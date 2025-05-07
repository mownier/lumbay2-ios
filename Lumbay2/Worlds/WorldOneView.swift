import SwiftUI
import SpriteKit
import Lumbay2cl

struct WorldOneView: View {
    @Environment(\.worldOneStatus) var status: Binding<Lumbay2sv_WorldOneStatus>
    @Environment(\.worldOneObject) var object: Binding<Lumbay2sv_WorldOneObject?>
    @Environment(\.worldOneRegionID) var regionID: Binding<Lumbay2sv_WorldOneRegionId>
    @Environment(\.worldOneAssignedStone) var assignedStone: Binding<WorldOneAssignedStone>
    @Environment(\.worldOneScore) var score: Binding<Lumbay2sv_WorldOneScore>
    @Environment(\.gameStatus) var gameStatus: Binding<Lumbay2sv_GameStatus>
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
                switch status.wrappedValue {
                case .playerOneWins:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("You win")
                    case .playerTwoStone:
                        Text("You lose")
                    default:
                        Text("Player one wins")
                    }
                    restartAndExitButtons()
                case .playerOneWinsByOutOfMoves:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("You win by out of moves")
                    case .playerTwoStone:
                        Text("You lose by out of moves")
                    default:
                        Text("Player one wins by out of moves")
                    }
                    restartAndExitButtons()
                case .playerTwoWins:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("You lose")
                    case .playerTwoStone:
                        Text("You win")
                    default:
                        Text("Player two wins")
                    }
                    restartAndExitButtons()
                case .playerTwoWinsByOutOfMoves:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("You lose by out of moves")
                    case .playerTwoStone:
                        Text("You win by out of moves")
                    default:
                        Text("Player two wins by out of moves")
                    }
                    restartAndExitButtons()
                case .playerOneMoved, .playerTwoFirstMove:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("Wait for your turn")
                    case .playerTwoStone:
                        Text("Your turn")
                    default:
                        Text("Player one moved. Player two's turn to move.")
                    }
                case .playerTwoMoved, .playerOneFirstMove:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("Your turn")
                    case .playerTwoStone:
                        Text("Wait for your turn")
                    default:
                        Text("Player two moved. Player one's turn to move.")
                    }
                case .playerOneConfirmsRestart:
                    switch assignedStone.wrappedValue {
                    case .playerOneStone:
                        Text("You confirm for restart")
                        Text("Do you want to cancel?")
                        exitButton(text: "Yes")
                    case .playerTwoStone:
                        Text("Other player confirms for restart")
                        restartAndExitButtons()
                    default:
                        Text("Player one confirms restarts")
                    }
                case .playerTwoConfirmsRestart:
                    switch assignedStone.wrappedValue {
                    case .playerTwoStone:
                        Text("You confirm for restart")
                        Text("Do you want to cancel?")
                        exitButton(text: "Yes")
                    case .playerOneStone:
                        Text("Other player confirms for restart")
                        restartAndExitButtons()
                    default:
                        Text("Player two confirms restarts")
                    }
                default:
                    Text("WorldOne status not handled: \(status.wrappedValue)")
                }
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    Text("Your score: \(score.player1.wrappedValue)")
                    Text("Other score: \(score.player2.wrappedValue)")
                    HStack {
                        Text("Your stone")
                        Circle()
                            .fill(Color(uiColor: gameScene.yourStoneColor))
                            .frame(width: 24, height: 24)
                    }
                case .playerTwoStone:
                    Text("Your score: \(score.player2.wrappedValue)")
                    Text("Other score: \(score.player1.wrappedValue)")
                    HStack {
                        Text("Your stone")
                        Circle()
                            .fill(Color(uiColor: gameScene.yourStoneColor))
                            .frame(width: 24, height: 24)
                    }
                default:
                    Text("Player 1 score: \(score.player1.wrappedValue)")
                    Text("Player 2 score: \(score.player2.wrappedValue)")
                    HStack {
                        Text("Player 1 stone")
                        Circle()
                            .fill(Color(uiColor: gameScene.yourStoneColor))
                            .frame(width: 24, height: 24)
                    }
                    HStack {
                        Text("Player 2 stone")
                        Circle()
                            .fill(Color(uiColor: gameScene.otherStoneColor))
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.trailing, 32)
            .padding(.top, 32)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder func exitButton(text: String) -> some View {
        Button(action: {
            Task {
                do {
                    try await client.exitWorld()
                } catch {
                    print(error)
                }
            }
        }) {
            Text(text)
        }
    }
    
    @ViewBuilder func restartAndExitButtons() -> some View {
        Button(action: {
            Task {
                do {
                    try await client.restartWorld()
                } catch {
                    print(error)
                }
            }
        }) {
            Text("Restart")
        }
        exitButton(text: "Exit")
    }
}

enum WorldOneAssignedStone {
    case none
    case playerOneStone
    case playerTwoStone
}
