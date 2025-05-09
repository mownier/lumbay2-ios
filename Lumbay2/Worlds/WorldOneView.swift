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
        VStack(spacing: 12) {
            exitButton()
            scoreTexts()
            switch status.wrappedValue {
            case .playerOneWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("You win", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("You lose", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerOneWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("You win^*", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("You lose^*", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerTwoWins:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("You lose", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("You win", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerTwoWinsByOutOfMoves:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("You lose^*", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("You win^*", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerOneMoved, .playerTwoFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("Wait", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("Your turn", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerTwoMoved, .playerOneFirstMove:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("Your turn", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("Wait", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerOneConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("Restarted", "ruby_stone_small", "dark_red")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("Restarted", "emerald_stone_small", "dark_green")
                default:
                    EmptyView()
                }
            case .playerTwoConfirmsRestart:
                switch assignedStone.wrappedValue {
                case .playerOneStone:
                    TrailingAlignedImageTextWithBkg("Restarted", "emerald_stone_small", "dark_green")
                case .playerTwoStone:
                    TrailingAlignedImageTextWithBkg("Restarted", "ruby_stone_small", "dark_red")
                default:
                    EmptyView()
                }
            default:
                EmptyView()
            }
            layoutRestartButton()
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
    
    @ViewBuilder func layoutRestartButton() -> some View {
        switch status.wrappedValue {
        case .playerOneWins,
                .playerTwoWins,
                .playerOneWinsByOutOfMoves,
                .playerTwoWinsByOutOfMoves:
            restartButton()
        case .playerOneConfirmsRestart:
            if assignedStone.wrappedValue == .playerTwoStone {
                restartButton()
            }
        case .playerTwoConfirmsRestart:
            if assignedStone.wrappedValue == .playerOneStone {
                restartButton()
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder func scoreTexts() -> some View {
        switch assignedStone.wrappedValue {
        case .playerOneStone:
            TrailingAlignedImageTextWithBkg(
                "You: \(score.player1.wrappedValue)",
                "ruby_stone_small",
                "dark_red"
            )
            TrailingAlignedImageTextWithBkg(
                "Opponent: \(score.player2.wrappedValue)",
                "emerald_stone_small",
                "dark_green"
            )
        case .playerTwoStone:
            TrailingAlignedImageTextWithBkg(
                "You: \(score.player2.wrappedValue)",
                "emerald_stone_small",
                "dark_green"
            )
            TrailingAlignedImageTextWithBkg(
                "Opponent: \(score.player1.wrappedValue)",
                "ruby_stone_small",
                "dark_red"
            )
        default:
            EmptyView()
        }
    }
}

enum WorldOneAssignedStone {
    case none
    case playerOneStone
    case playerTwoStone
}

struct TrailingAlignedImageTextWithBkg: View {
    let text: String
    let imageName: String
    let colorName: String
    
    init(_ text: String, _ imageName: String, _ colorName: String) {
        self.text = text
        self.imageName = imageName
        self.colorName = colorName
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            HStack(spacing: 2) {
                Image(imageName)
                    .padding(.trailing, 8)
                    .padding(.leading, 8)
                Text(text)
                    .foregroundStyle(Color.white)
                    .modifier(TextWithCustomFont(fontSize: 18.0))
                    .padding(.trailing, 8)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(colorName))
                    .frame(height: 32)
            }
        }
    }
}
