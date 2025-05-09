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
    @Environment(\.initialDataWorldOneObjects) var initialDataObjects: Binding<[Lumbay2sv_WorldOneObject]>
    @Environment(\.client) var client: Lumbay2Client
    
    @StateObject var gameScene: GameScene3 = GameScene3(size: UIScreen.main.bounds.size)
    
    var yourStoneColor: UIColor {
        switch assignedStone.wrappedValue {
        case .playerOneStone: return .magenta
        case .playerTwoStone: return .yellow
        default: return .cyan
        }
    }

    var otherStoneColor: UIColor {
        switch assignedStone.wrappedValue {
        case .playerOneStone: return .yellow
        case .playerTwoStone: return .magenta
        default: return .cyan
        }
    }
    
    var gameSceneWithParameters: GameScene3 {
        return gameScene
            .setClient(client)
            .setAssignedStone(assignedStone.wrappedValue)
            .setWorldStatus(status.wrappedValue)
            .setWorldRegionID(regionID.wrappedValue)
            .setInitialDataObjects(initialDataObjects.wrappedValue)
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                spriteView(size: CGSize(width: geo.size.width * 0.7, height: geo.size.height))
                controlsView(size: CGSize(width: geo.size.width * 0.3, height: geo.size.height))
            }
        }
    }
    
    @ViewBuilder func spriteView(size: CGSize) -> some View {
        SpriteView(scene: gameSceneWithParameters.setupSize(size: size), options: [.allowsTransparency])
            .onChange(of: status.wrappedValue) { _, newValue in
                gameScene.updateWorldStatus(newValue)
            }
            .onChange(of: object.wrappedValue) { _, newValue in
                gameScene.updateWorldObject(newValue ?? Lumbay2sv_WorldOneObject())
            }
            .frame(width: size.width)
    }
    
    @ViewBuilder func controlsView(size: CGSize) -> some View {
        VStack {
            switch status.wrappedValue {
            case .playerOneWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You win")
                case .playerTwoStone:
                    TrailingAlignedText("You lose")
                default:
                    TrailingAlignedText("Player one wins")
                }
                restartAndExitButtons()
            case .playerOneWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You win by out of moves")
                case .playerTwoStone:
                    TrailingAlignedText("You lose by out of moves")
                default:
                    TrailingAlignedText("Player one wins by out of moves")
                }
                restartAndExitButtons()
            case .playerTwoWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You lose")
                case .playerTwoStone:
                    TrailingAlignedText("You win")
                default:
                    TrailingAlignedText("Player two wins")
                }
                restartAndExitButtons()
            case .playerTwoWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You lose by out of moves")
                case .playerTwoStone:
                    TrailingAlignedText("You win by out of moves")
                default:
                    TrailingAlignedText("Player two wins by out of moves")
                }
                restartAndExitButtons()
            case .playerOneMoved, .playerTwoFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("Wait for your turn")
                case .playerTwoStone:
                    TrailingAlignedText("Your turn")
                default:
                    TrailingAlignedText("Player one moved. Player two's turn to move.")
                }
            case .playerTwoMoved, .playerOneFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("Your turn")
                case .playerTwoStone:
                    TrailingAlignedText("Wait for your turn")
                default:
                    TrailingAlignedText("Player two moved. Player one's turn to move.")
                }
            case .playerOneConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You confirm for restart")
                    TrailingAlignedText("Do you want to cancel?")
                    exitButton(text: "Yes")
                case .playerTwoStone:
                    TrailingAlignedText("Other player confirms for restart")
                    restartAndExitButtons()
                default:
                    TrailingAlignedText("Player one confirms restarts")
                }
            case .playerTwoConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerTwoStone:
                    TrailingAlignedText("You confirm for restart")
                    TrailingAlignedText("Do you want to cancel?")
                    exitButton(text: "Yes")
                case .playerOneStone:
                    TrailingAlignedText("Other player confirms for restart")
                    restartAndExitButtons()
                default:
                    TrailingAlignedText("Player two confirms restarts")
                }
            default:
                TrailingAlignedText("WorldOne status not handled: \(status.wrappedValue)")
            }
            switch assignedStone.wrappedValue {
            case .playerOneStone:
                TrailingAlignedText("Your score: \(score.player1.wrappedValue)")
                TrailingAlignedText("Other score: \(score.player2.wrappedValue)")
                HStack {
                    Spacer()
                    TrailingAlignedText("Your stone")
                    Circle()
                        .fill(Color(uiColor: yourStoneColor))
                        .frame(width: 24, height: 24)
                }
            case .playerTwoStone:
                TrailingAlignedText("Your score: \(score.player2.wrappedValue)")
                TrailingAlignedText("Other score: \(score.player1.wrappedValue)")
                HStack {
                    Spacer()
                    TrailingAlignedText("Your stone")
                    Circle()
                        .fill(Color(uiColor: yourStoneColor))
                        .frame(width: 24, height: 24)
                }
            default:
                TrailingAlignedText("Player 1 score: \(score.player1.wrappedValue)")
                TrailingAlignedText("Player 2 score: \(score.player2.wrappedValue)")
                HStack {
                    Spacer()
                    TrailingAlignedText("Player 1 stone")
                    Circle()
                        .fill(Color(uiColor: yourStoneColor))
                        .frame(width: 24, height: 24)
                }
                HStack {
                    Spacer()
                    TrailingAlignedText("Player 2 stone")
                    Circle()
                        .fill(Color(uiColor: otherStoneColor))
                        .frame(width: 24, height: 24)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 12))
        .frame(width: size.width)
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

struct TrailingAlignedText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .modifier(TextWithCustomFont(fontSize: 24.0))
        }
    }
}
