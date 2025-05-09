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
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
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
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
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
            exitButton()
            switch status.wrappedValue {
            case .playerOneWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You win")
                case .playerTwoStone:
                    TrailingAlignedText("You lose")
                default:
                    EmptyView()
                }
            case .playerOneWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You win by out of moves")
                case .playerTwoStone:
                    TrailingAlignedText("You lose by out of moves")
                default:
                    EmptyView()
                }
            case .playerTwoWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You lose")
                case .playerTwoStone:
                    TrailingAlignedText("You win")
                default:
                    EmptyView()
                }
            case .playerTwoWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You lose by out of moves")
                case .playerTwoStone:
                    TrailingAlignedText("You win by out of moves")
                default:
                    EmptyView()
                }
            case .playerOneMoved, .playerTwoFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("Wait for your turn")
                case .playerTwoStone:
                    TrailingAlignedText("Your turn")
                default:
                    EmptyView()
                }
            case .playerTwoMoved, .playerOneFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("Your turn")
                case .playerTwoStone:
                    TrailingAlignedText("Wait for your turn")
                default:
                    EmptyView()
                }
            case .playerOneConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedText("You confirm for restart")
                    TrailingAlignedText("Do you want to cancel?")
                case .playerTwoStone:
                    TrailingAlignedText("Other player confirms for restart")
                default:
                    EmptyView()
                }
            case .playerTwoConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerTwoStone:
                    TrailingAlignedText("You confirm for restart")
                    TrailingAlignedText("Do you want to cancel?")
                case .playerOneStone:
                    TrailingAlignedText("Other player confirms for restart")
                default:
                    EmptyView()
                }
            default:
                EmptyView()
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
                EmptyView()
            }
            switch status.wrappedValue {
            case .playerOneWins,
                    .playerTwoWins,
                    .playerOneWinsByOutOfMoves,
                    .playerTwoWinsByOutOfMoves:
                restartButton()
            default:
                EmptyView()
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 12))
        .frame(width: size.width)
    }
    
    @ViewBuilder func exitButton() -> some View {
        HStack {
            Spacer()
            Button("Exit") {
                Task {
                    do {
                        try await client.exitWorld()
                    } catch {
                        showError = true
                        errorMessage = "Unable to exit game. Please try again."
                    }
                }
            }
            .modifier(ButtonWithStretchableBkg(style: "3", width: 160))
        }
    }
    
    @ViewBuilder func restartButton() -> some View {
        HStack {
            Spacer()
            Button("Restart") {
                Task {
                    do {
                        try await client.restartWorld()
                    } catch {
                        showError = true
                        errorMessage = "Unable to restart. Please try again."
                    }
                }
            }
            .modifier(ButtonWithStretchableBkg(style: "4", width: 160))
        }
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
                .modifier(TextWithCustomFont(fontSize: 22.0))
        }
    }
}
