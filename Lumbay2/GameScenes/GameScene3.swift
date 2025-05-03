import SpriteKit
import UIKit

// This is okay

class GameScene3Stone1: SKSpriteNode {
    var currentCircleNumber: Int?

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = false
    }

    convenience init(color: UIColor, size: CGSize) {
        let circularTexture = GameScene3Stone1.generateCircularTexture(with: color, diameter: size.width)
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
        if let scene = scene as? GameScene3, scene.currentStoneCount1 == scene.maxStones {
            scene.selectStone(self)
        }
    }
}

class GameScene3Stone2: SKSpriteNode {
    var currentCircleNumber: Int?

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init(color: UIColor, size: CGSize) {
        // Customize the texture or color as needed for the special node
        let circularTexture = GameScene3Stone2.generateCircularTexture(with: color, diameter: size.width)
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

class GameScene3: SKScene {

    let circleRadius: CGFloat = 30
    var circles: [Int: SKShapeNode] = [:]
    let maxStones = 3
    var currentStoneCount1 = 0 // Counter for GameScene3Stone1
    var selectedStone: GameScene3Stone1? {
        didSet {
            oldValue?.removeAllActions()
            if let selectedStone = selectedStone {
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

    // Track GameScene3Stone2 nodes
    var stone2Nodes: [GameScene3Stone2] = []
    let maxStone2Nodes = 1 // Example limit for GameScene3Stone2 nodes

    override func didMove(to view: SKView) {
        backgroundColor = .lightGray

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

        // Example of adding a GameScene3Stone2 node on a specific circle
        let cirlceNum = (1...9).randomElement()!
        if let circle5 = circles[cirlceNum], stone2Nodes.count < maxStone2Nodes {
            let stone2 = GameScene3Stone2(color: .yellow, size: CGSize(width: circleRadius * 2, height: circleRadius * 2))
            stone2.position = circle5.position
            stone2.zPosition = 1
            stone2.currentCircleNumber = cirlceNum
            stone2.name = "stone2_on_circle\(cirlceNum)"
            addChild(stone2)
            stone2Nodes.append(stone2)
        }
    }

    func selectStone(_ stone: GameScene3Stone1) {
        selectedStone = stone
    }

    func applyPulseEffect(to node: SKNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        node.run(repeatPulse, withKey: "pulseAnimation")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if currentStoneCount1 == maxStones, let selectedStone = selectedStone, let currentCircleNumber = selectedStone.currentCircleNumber {
            for (targetCircleNumber, circleNode) in circles {
                let distance = sqrt(pow(location.x - circleNode.position.x, 2) + pow(location.y - circleNode.position.y, 2))
                if distance < circleRadius {
                    if let allowedPaths = movementPaths[currentCircleNumber], allowedPaths.contains(targetCircleNumber) {
                        let isOccupied = children.contains(where: {
                            if let stone1 = $0 as? GameScene3Stone1, stone1.currentCircleNumber == targetCircleNumber {
                                return true
                            }
                            if let stone2 = $0 as? GameScene3Stone2, stone2.currentCircleNumber == targetCircleNumber {
                                return true
                            }
                            return false
                        })

                        if !isOccupied {
                            let moveAction = SKAction.move(to: circleNode.position, duration: 0.2)
                            let completionAction = SKAction.run {
                                selectedStone.position = circleNode.position
                                selectedStone.name = "stone1_on_circle\(targetCircleNumber)"
                                selectedStone.currentCircleNumber = targetCircleNumber
                                self.selectedStone = nil
                            }
                            let moveSequence = SKAction.sequence([moveAction, completionAction])
                            selectedStone.run(moveSequence)
                            return
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
            }
            self.selectedStone = nil
            return
        } else {
            if currentStoneCount1 < maxStones {
                for (circleNumber, circleNode) in circles {
                    let distance = sqrt(pow(location.x - circleNode.position.x, 2) + pow(location.y - circleNode.position.y, 2))
                    if distance < circleRadius {
                        let isOccupied = children.contains(where: {
                            if let stone1 = $0 as? GameScene3Stone1, stone1.currentCircleNumber == circleNumber {
                                return true
                            }
                            if let stone2 = $0 as? GameScene3Stone2, stone2.currentCircleNumber == circleNumber {
                                return true
                            }
                            return false
                        })

                        if !isOccupied {
                            let magentaStone = GameScene3Stone1(color: .magenta, size: CGSize(width: circleRadius * 2, height: circleRadius * 2))
                            magentaStone.position = circleNode.position
                            magentaStone.zPosition = 1
                            magentaStone.name = "stone1_on_circle\(circleNumber)"
                            magentaStone.currentCircleNumber = circleNumber
                            addChild(magentaStone)
                            currentStoneCount1 += 1

                            if currentStoneCount1 == maxStones {
                                for child in children {
                                    if let stone = child as? GameScene3Stone1 {
                                        stone.isUserInteractionEnabled = true
                                    }
                                }
                            }
                        }
                        break
                    }
                }
            }
        }
    }
}
