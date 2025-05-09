import SwiftUI
import SpriteKit
import UIKit
import Lumbay2cl
import Combine

// This is okay

class GameScene3YourStone: SKSpriteNode {
    var currentCircleNumber: Int?

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = false
    }

    convenience init(color: UIColor, size: CGSize) {
        let circularTexture = GameScene3YourStone.generateCircularTexture(with: color, diameter: size.width)
        self.init(texture: circularTexture, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func generateCircularTexture(with color: UIColor, diameter: CGFloat) -> SKTexture? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        let image = renderer.image { context in
            color.setFill()
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)))
        }
        return SKTexture(image: image)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = scene as? GameScene3, scene.yourStoneScount == scene.maxStones {
            scene.selectStone(self)
        }
    }
}

class GameScene3OtherStone: SKSpriteNode {
    var currentCircleNumber: Int?

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init(color: UIColor, size: CGSize) {
        // Customize the texture or color as needed for the special node
        let circularTexture = GameScene3OtherStone.generateCircularTexture(with: color, diameter: size.width)
        self.init(texture: circularTexture, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func generateCircularTexture(with color: UIColor, diameter: CGFloat) -> SKTexture? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        let image = renderer.image { context in
            color.setFill()
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)))
        }
        return SKTexture(image: image)
    }
}

class GameScene3PlayerStone {
    let objectId: Lumbay2sv_WorldOneObjectId
    var circleNumber: Int?
    init(objectId: Lumbay2sv_WorldOneObjectId, circleNumber: Int? = nil) {
        self.objectId = objectId
        self.circleNumber = circleNumber
    }
}

class GameScene3: SKScene, ObservableObject {

    let circleRadius: CGFloat = 30
    var circles: [Int: SKShapeNode] = [:]
    let maxStones = 3
    var yourStoneScount = 0
    var yourSelectedStone: GameScene3YourStone? {
        didSet {
            oldValue?.removeAllActions()
            if let selectedStone = yourSelectedStone {
                applyPulseEffect(to: selectedStone)
            }
        }
    }

    let movementPaths: [Int: [Int]] = [
        1: [2, 4, 5],
        2: [1, 5, 3],
        3: [2, 6, 5],
        4: [1, 5, 7],
        5: [1, 2, 3, 4, 6, 7, 8, 9],
        6: [3, 5, 9],
        7: [4, 5, 8],
        8: [5, 7, 9],
        9: [5, 6, 8]
    ]
    
    let circleLocations: [Int: [Int]] = [
        1: [0, 0],
        2: [1, 0],
        3: [2, 0],
        4: [0, 1],
        5: [1, 1],
        6: [2, 1],
        7: [0, 2],
        8: [1, 2],
        9: [2, 2],
    ]

    var otherStoneCount = 0
    
    var player1Stones: [GameScene3PlayerStone] = [
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerOneStoneOne, circleNumber: nil),
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerOneStoneTwo, circleNumber: nil),
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerOneStoneThree, circleNumber: nil)
    ]
    
    var player2Stones: [GameScene3PlayerStone] = [
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerTwoStoneOne, circleNumber: nil),
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerTwoStoneTwo, circleNumber: nil),
        GameScene3PlayerStone(objectId: Lumbay2sv_WorldOneObjectId.playerTwoStoneThree, circleNumber: nil)
    ]
    
    var worldRegionID: Lumbay2sv_WorldOneRegionId = .none
    var worldStatus: Lumbay2sv_WorldOneStatus = .none
    var worldObject: Lumbay2sv_WorldOneObject = Lumbay2sv_WorldOneObject()
    var assignedStone: WorldOneAssignedStone = .none
    var initialDataObjects: [Lumbay2sv_WorldOneObject] = []
    var client: Lumbay2Client!
    
    var yourStoneColor: UIColor {
        switch assignedStone {
        case .playerOneStone: return .magenta
        case .playerTwoStone: return .yellow
        default: return .cyan
        }
    }

    var otherStoneColor: UIColor {
        switch assignedStone {
        case .playerOneStone: return .yellow
        case .playerTwoStone: return .magenta
        default: return .cyan
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear

        let rows = 3
        let cols = 3
        let spacing: CGFloat = 80

        let totalWidth = CGFloat(cols) * (2 * circleRadius + spacing) - spacing
        let totalHeight = CGFloat(rows) * (2 * circleRadius + spacing) - spacing

        let startX = -totalWidth / 2 + circleRadius
        let startY = totalHeight / 2 - circleRadius

        let sceneCenter = CGPoint(x: frame.midX, y: frame.midY)

        var circleNumber = 1
        for row in 0..<rows {
            for col in 0..<cols {
                let x = sceneCenter.x + startX + CGFloat(col) * (2 * circleRadius + spacing)
                let y = sceneCenter.y + startY - CGFloat(row) * (2 * circleRadius + spacing)

                let circle = SKShapeNode(circleOfRadius: circleRadius)
                circle.fillColor = .black
                circle.strokeColor = .black
                circle.lineWidth = 2
                circle.name = "circle\(circleNumber)"
                circle.position = CGPoint(x: x, y: y)
                circle.isUserInteractionEnabled = false
                addChild(circle)

                circles[circleNumber] = circle
                circleNumber += 1
            }
        }

        func drawPath(from circle1: Int, to circle2: Int) {
            guard let startCircle = circles[circle1], let endCircle = circles[circle2] else {
                return
            }

            let path = UIBezierPath()
            path.move(to: startCircle.position)
            path.addLine(to: endCircle.position)

            let line = SKShapeNode(path: path.cgPath)
            line.strokeColor = .black
            line.lineWidth = 2
            addChild(line)
        }

        drawPath(from: 1, to: 2)
        drawPath(from: 1, to: 4)
        drawPath(from: 1, to: 5)

        drawPath(from: 2, to: 1)
        drawPath(from: 2, to: 5)
        drawPath(from: 2, to: 3)

        drawPath(from: 3, to: 2)
        drawPath(from: 3, to: 6)
        drawPath(from: 3, to: 5)

        drawPath(from: 4, to: 1)
        drawPath(from: 4, to: 5)
        drawPath(from: 4, to: 7)

        drawPath(from: 5, to: 1)
        drawPath(from: 5, to: 2)
        drawPath(from: 5, to: 3)
        drawPath(from: 5, to: 4)
        drawPath(from: 5, to: 6)
        drawPath(from: 5, to: 7)
        drawPath(from: 5, to: 8)
        drawPath(from: 5, to: 9)

        drawPath(from: 6, to: 3)
        drawPath(from: 6, to: 5)
        drawPath(from: 6, to: 9)

        drawPath(from: 7, to: 4)
        drawPath(from: 7, to: 5)
        drawPath(from: 7, to: 8)

        drawPath(from: 8, to: 5)
        drawPath(from: 8, to: 7)
        drawPath(from: 8, to: 9)

        drawPath(from: 9, to: 5)
        drawPath(from: 9, to: 6)
        drawPath(from: 9, to: 8)
        
        initialDataObjects.forEach { object in
            updateWorldObject(object)
        }
        initialDataObjects.removeAll()
    }
    
    func setClient(_ value: Lumbay2Client) -> GameScene3 {
        client = value
        return self
    }
    
    func setAssignedStone(_ value: WorldOneAssignedStone) -> GameScene3 {
        assignedStone = value
        return self
    }
    
    func setWorldRegionID(_ value: Lumbay2sv_WorldOneRegionId) -> GameScene3 {
        worldRegionID = value
        return self
    }
    
    func setWorldStatus(_ value: Lumbay2sv_WorldOneStatus) -> GameScene3 {
        worldStatus = value
        return self
    }
    
    func setInitialDataObjects(_ value: [Lumbay2sv_WorldOneObject]) -> GameScene3 {
        initialDataObjects = value
        return self
    }

    func selectStone(_ stone: GameScene3YourStone) {
        if yourTurnToMove() {
            yourSelectedStone = stone
        }
    }

    func applyPulseEffect(to node: SKNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        node.run(repeatPulse, withKey: "pulseAnimation")
    }
    
    func yourTurnToMove() -> Bool {
        switch worldStatus {
        case .playerOneMoved, .playerTwoFirstMove:
            if assignedStone == .playerTwoStone {
                return true
            }
        case .playerTwoMoved, .playerOneFirstMove:
            if assignedStone == .playerOneStone {
                return true
            }
        default:
            break
        }
        return false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if yourTurnToMove(), yourStoneScount == maxStones, let selectedStone = yourSelectedStone, let currentCircleNumber = selectedStone.currentCircleNumber {
            for (targetCircleNumber, circleNode) in circles {
                let distance = sqrt(pow(location.x - circleNode.position.x, 2) + pow(location.y - circleNode.position.y, 2))
                if distance < circleRadius {
                    if let allowedPaths = movementPaths[currentCircleNumber], allowedPaths.contains(targetCircleNumber) {
                        let isOccupied = children.contains(where: {
                            if let stone1 = $0 as? GameScene3YourStone, stone1.currentCircleNumber == targetCircleNumber {
                                return true
                            }
                            if let stone2 = $0 as? GameScene3OtherStone, stone2.currentCircleNumber == targetCircleNumber {
                                return true
                            }
                            return false
                        })
                        if !isOccupied {
                            Task {
                                do {
                                    var data = Lumbay2sv_ProcessWorldOneObjectRequest()
                                    switch assignedStone {
                                    case .playerOneStone:
                                        var count = 0
                                        for playerStone in player1Stones {
                                            if playerStone.circleNumber == currentCircleNumber {
                                                data.objectID = playerStone.objectId
                                                count += 1
                                            }
                                        }
                                        if count > 1 {
                                            throw Lumbay2Client.Errors.unknown
                                        }
                                    case .playerTwoStone:
                                        var count = 0
                                        for playerStone in player2Stones {
                                            if playerStone.circleNumber == currentCircleNumber {
                                                data.objectID = playerStone.objectId
                                                count += 1
                                            }
                                        }
                                        if count > 1 {
                                            throw Lumbay2Client.Errors.unknown
                                        }
                                    default:
                                        throw Lumbay2Client.Errors.unknown
                                    }
                                    let circleLocation = circleLocations[targetCircleNumber]!
                                    var worldLocation = Lumbay2sv_WorldLocation()
                                    worldLocation.x = Int64(circleLocation[0])
                                    worldLocation.y = Int64(circleLocation[1])
                                    data.regionID = worldRegionID
                                    data.objectStatus = .moved
                                    data.objectData = Lumbay2sv_WorldOneObjectData()
                                    data.objectData.type = .location(worldLocation)
                                    try await client.processWorldOneObject(data)
                                } catch {
                                    print("move error", error)
                                    self.yourSelectedStone = nil
                                }
                            }
                            return
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
            }
            self.yourSelectedStone = nil
            return
        } else if yourTurnToMove() {
            if yourStoneScount < maxStones {
                for (circleNumber, circleNode) in circles {
                    let distance = sqrt(pow(location.x - circleNode.position.x, 2) + pow(location.y - circleNode.position.y, 2))
                    if distance < circleRadius {
                        let isOccupied = children.contains(where: {
                            if let stone1 = $0 as? GameScene3YourStone, stone1.currentCircleNumber == circleNumber {
                                return true
                            }
                            if let stone2 = $0 as? GameScene3OtherStone, stone2.currentCircleNumber == circleNumber {
                                return true
                            }
                            return false
                        })
                        if !isOccupied {
                            Task {
                                do {
                                    var data = Lumbay2sv_ProcessWorldOneObjectRequest()
                                    switch assignedStone {
                                    case .playerOneStone:
                                        for entry in player1Stones {
                                            if entry.circleNumber == nil {
                                                data.objectID = entry.objectId
                                                break
                                            }
                                        }
                                    case .playerTwoStone:
                                        for entry in player2Stones {
                                            if entry.circleNumber == nil {
                                                data.objectID = entry.objectId
                                                break
                                            }
                                        }
                                    default:
                                        throw Lumbay2Client.Errors.unknown
                                    }
                                    let circleLocation = circleLocations[circleNumber]!
                                    var worldLocation = Lumbay2sv_WorldLocation()
                                    worldLocation.x = Int64(circleLocation[0])
                                    worldLocation.y = Int64(circleLocation[1])
                                    data.regionID = worldRegionID
                                    data.objectStatus = .spawned
                                    data.objectData = Lumbay2sv_WorldOneObjectData()
                                    data.objectData.location = worldLocation
                                    try await client.processWorldOneObject(data)
                                } catch {
                                    print("spawn error", error)
                                }
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    
    func reset() {
        yourStoneScount = 0
        yourSelectedStone = nil
        otherStoneCount = 0
        player1Stones.forEach { stone in
            stone.circleNumber = nil
        }
        player2Stones.forEach { stone in
            stone.circleNumber = nil
        }
        children.forEach { node in
            if node is GameScene3YourStone || node is GameScene3OtherStone {
                node.removeFromParent()
            }
        }
    }
    
    func updateWorldStatus(_ value: Lumbay2sv_WorldOneStatus) {
        worldStatus = value
        switch value {
        case .playerOneFirstMove, .playerTwoFirstMove:
            reset()
        default:
            break
        }
    }
    
    func updateWorldObject(_ value: Lumbay2sv_WorldOneObject) {
        worldObject = value
        switch worldObject.data.type {
        case .location(let location):
            if worldObject.id == .playerOneStoneOne ||
                worldObject.id == .playerOneStoneTwo ||
                worldObject.id == .playerOneStoneThree {
                handlePlayerStone(worldObject.id, worldObject.status, location, assignedStone == .playerOneStone, player1Stones)
            } else if worldObject.id == .playerTwoStoneOne ||
                        worldObject.id == .playerTwoStoneTwo ||
                        worldObject.id == .playerTwoStoneThree {
                handlePlayerStone(worldObject.id, worldObject.status, location, assignedStone == .playerTwoStone, player2Stones)
            }
        default:
            break
        }
    }
    
    func handlePlayerStone(
        _ worldObjectID: Lumbay2sv_WorldOneObjectId,
        _ worldObjectStatus: Lumbay2sv_WorldOneObjectStatus,
        _ worldLocation: Lumbay2sv_WorldLocation,
        _ isThisYourStone: Bool,
        _ playerStones: [GameScene3PlayerStone]
    ) {
        switch worldObjectStatus {
        case .spawned:
            for (circleNum, circleLoc) in circleLocations {
                if let circleNode = circles[circleNum], circleLoc[0] == worldLocation.x && circleLoc[1] == worldLocation.y {
                    if isThisYourStone && yourStoneScount < maxStones {
                        let stone = GameScene3YourStone(
                            color: yourStoneColor,
                            size: CGSize(width: circleRadius * 2, height: circleRadius * 2)
                        )
                        stone.currentCircleNumber = circleNum
                        stone.position = circleNode.position
                        stone.zPosition = 1
                        addChild(stone)
                        yourStoneScount += 1
                        if yourStoneScount == maxStones {
                            for child in children {
                                if let stone = child as? GameScene3YourStone {
                                    stone.isUserInteractionEnabled = true
                                }
                            }
                        }
                        for playerStone in playerStones {
                            if playerStone.objectId == worldObjectID {
                                playerStone.circleNumber = circleNum
                                break
                            }
                        }
                    } else if !isThisYourStone && otherStoneCount < maxStones {
                        let stone = GameScene3OtherStone(
                            color: otherStoneColor,
                            size: CGSize(width: circleRadius * 2, height: circleRadius * 2)
                        )
                        stone.currentCircleNumber = circleNum
                        stone.position = circleNode.position
                        stone.zPosition = 1
                        addChild(stone)
                        otherStoneCount += 1
                        for playerStone in playerStones {
                            if playerStone.objectId == worldObjectID {
                                playerStone.circleNumber = circleNum
                                break
                            }
                        }
                    }
                    break
                }
            }
        case .moved:
            for (circleNum, circleLoc) in circleLocations {
                if let circleNode = circles[circleNum], circleLoc[0] == worldLocation.x && circleLoc[1] == worldLocation.y {
                    if isThisYourStone {
                        if let selectedStone = yourSelectedStone {
                            let moveAction = SKAction.move(to: circleNode.position, duration: 0.2)
                            let completionAction = SKAction.run {
                                selectedStone.position = circleNode.position
                                selectedStone.currentCircleNumber = circleNum
                                self.yourSelectedStone = nil
                            }
                            let moveSequence = SKAction.sequence([moveAction, completionAction])
                            selectedStone.run(moveSequence)
                            for playerStone in playerStones {
                                if playerStone.objectId == worldObjectID {
                                    playerStone.circleNumber = circleNum
                                    break
                                }
                            }
                        }
                    } else {
                        for playerStone in playerStones {
                            if playerStone.objectId == worldObjectID {
                                for child in children {
                                    if let stone = child as? GameScene3OtherStone,
                                       let currentCircleNumber = stone.currentCircleNumber,
                                       currentCircleNumber == playerStone.circleNumber {
                                        let moveAction = SKAction.move(to: circleNode.position, duration: 0.2)
                                        let completionAction = SKAction.run {
                                            stone.position = circleNode.position
                                            stone.currentCircleNumber = circleNum
                                        }
                                        let moveSequence = SKAction.sequence([moveAction, completionAction])
                                        stone.run(moveSequence)
                                        playerStone.circleNumber = circleNum
                                        break
                                    }
                                }
                                break
                            }
                        }
                    }
                    break
                }
            }
        default:
            break
        }
    }
}
