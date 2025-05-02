import SpriteKit
import UIKit

class GameScene2: SKScene {

    let circleRadius: CGFloat = 8
    let largeStoneRadius: CGFloat = 24
    let gridSpacing: CGFloat = 100
    var circleNodes: [Int: SKShapeNode] = [:]
    var occupiedCircles: [SKShapeNode: Int] = [:]
    let numberFontSize: CGFloat = 20
    var magentaStones: [SKShapeNode] = []
    var cyanStones: [SKShapeNode] = []
    var initialStonePositions: [SKShapeNode: CGPoint] = [:]
    var selectedNode: SKShapeNode?
    var previousPosition: CGPoint?
    let numRows = 3
    let numCols = 3
    var gridOrigin: CGPoint!
    let gridSize: CGSize
    var resetButtonNode: SKShapeNode!
    var resetButtonLabel: SKLabelNode!
    var isTouchingResetButton: Bool = false

    let pathRules: [Int: [Int]] = [
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

    override init(size: CGSize) {
        gridSize = CGSize(width: 2 * circleRadius + gridSpacing, height: 2 * circleRadius + gridSpacing)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .lightGray

        let gridWidth = CGFloat(numCols) * gridSize.width
        let gridHeight = CGFloat(numRows) * gridSize.height
        gridOrigin = CGPoint(x: (size.width - gridWidth) / 2, y: (size.height - gridHeight) / 2)

        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var numberIndex = 0

        for row in 0..<numRows {
            for col in 0..<numCols {
                let x = gridOrigin.x + CGFloat(col) * gridSize.width + gridSize.width / 2
                let y = gridOrigin.y + CGFloat(2 - row) * gridSize.height + gridSize.height / 2

                let circle = SKShapeNode(circleOfRadius: circleRadius)
                circle.fillColor = .black
                circle.strokeColor = .black
                circle.lineWidth = 1
                circle.position = CGPoint(x: x, y: y)
                circle.name = "numberedCircle-\(numbers[numberIndex])"
                circleNodes[numbers[numberIndex]] = circle

                addChild(circle)
                numberIndex += 1
            }
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

        for i in 0..<3 {
            let cyanStone = createCircularStone(color: .cyan, radius: largeStoneRadius, name: "cyanStone-\(i)")
            let initialY = gridOrigin.y + CGFloat(i) * gridSize.height + gridSize.height / 2
            cyanStone.position = CGPoint(x: gridOrigin.x - (largeStoneRadius * 2 * 1.5), y: initialY)
            cyanStones.append(cyanStone)
            initialStonePositions[cyanStone] = cyanStone.position
            addChild(cyanStone)
            cyanStone.isUserInteractionEnabled = false
        }

        for i in 0..<3 {
            let magentaStone = createCircularStone(color: .magenta, radius: largeStoneRadius, name: "magentaStone-\(i)")
            let initialY = gridOrigin.y + CGFloat(i) * gridSize.height + gridSize.height / 2
            magentaStone.position = CGPoint(x: gridOrigin.x + gridWidth + (largeStoneRadius * 2 * 1.5), y: initialY)
            magentaStones.append(magentaStone)
            initialStonePositions[magentaStone] = magentaStone.position
            addChild(magentaStone)
            magentaStone.isUserInteractionEnabled = false
        }

        // Create the reset button background at the top right
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 40
        let cornerRadius: CGFloat = 5
        let pastelGreen = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0)
        let topMargin: CGFloat = 20 // Adjust vertical margin from the top
        let rightMargin: CGFloat = 20 // Adjust horizontal margin from the right

        resetButtonNode = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: cornerRadius)
        resetButtonNode.fillColor = pastelGreen
        resetButtonNode.strokeColor = .black
        resetButtonNode.lineWidth = 1
        resetButtonNode.position = CGPoint(x: size.width - buttonWidth / 2 - rightMargin, y: size.height - buttonHeight / 2 - topMargin)
        resetButtonNode.name = "resetButton"
        resetButtonNode.isUserInteractionEnabled = false

        // Create the reset button label
        resetButtonLabel = SKLabelNode(text: "Reset")
        resetButtonLabel.fontSize = 20
        resetButtonLabel.fontColor = .black
        resetButtonLabel.position = CGPoint(x: 0, y: -resetButtonNode.frame.height / 4)
        resetButtonLabel.isUserInteractionEnabled = false

        resetButtonNode.addChild(resetButtonLabel)
        addChild(resetButtonNode)
    }

    func createCircularStone(color: UIColor, radius: CGFloat, name: String) -> SKShapeNode {
        let stone = SKShapeNode(circleOfRadius: radius)
        stone.fillColor = color
        stone.strokeColor = .black
        stone.lineWidth = 1
        stone.name = name
        return stone
    }

    func drawPath(from startNumber: Int, to endNumber: Int) {
        if let startNode = circleNodes[startNumber], let endNode = circleNodes[endNumber] {
            let startPoint = startNode.position
            let endPoint = endNode.position

            let path = CGMutablePath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)

            let lineNode = SKShapeNode(path: path)
            lineNode.strokeColor = .black
            lineNode.lineWidth = 2
            lineNode.zPosition = -1
            addChild(lineNode)
        } else {
            print("Error: Could not find circle node for number \(startNumber) or \(endNumber)")
        }
    }

    func gridCoordinate(for worldPosition: CGPoint) -> CGPoint? {
        guard let origin = gridOrigin else { return nil }
        let dx = worldPosition.x - origin.x
        let dy = worldPosition.y - origin.y

        if dx >= 0 && dy >= 0 {
            let col = Int(dx / gridSize.width)
            let row = Int(dy / gridSize.height)

            if col < numCols && row < numRows {
                return CGPoint(x: CGFloat(col), y: CGFloat(row))
            }
        }
        return nil
    }

    func gridPosition(for gridCoordinate: CGPoint) -> CGPoint {
        guard let origin = gridOrigin else { return .zero }
        let x = origin.x + gridCoordinate.x * gridSize.width + gridSize.width / 2
        let y = origin.y + gridCoordinate.y * gridSize.height + gridSize.height / 2
        return CGPoint(x: x, y: y)
    }

    func resetGame() {
        occupiedCircles.removeAll()
        for stone in cyanStones {
            if let initialPosition = initialStonePositions[stone] {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.2)
                stone.run(moveAction)
            }
        }
        for stone in magentaStones {
            if let initialPosition = initialStonePositions[stone] {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.2)
                stone.run(moveAction)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        for node in touchedNodes {
            if node.name == "resetButton" {
                isTouchingResetButton = true
                break
            } else if let stone = node as? SKShapeNode, magentaStones.contains(stone) || cyanStones.contains(stone) {
                selectedNode = stone
                previousPosition = stone.position
                selectedNode?.zPosition = 1
                break
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedNode = selectedNode else { return }
        let touchLocation = touch.location(in: self)

        let gridWidth = CGFloat(numCols) * gridSize.width
        let gridHeight = CGFloat(numRows) * gridSize.height
        let gridFrame = CGRect(origin: gridOrigin, size: CGSize(width: gridWidth, height: gridHeight))

        if let occupiedCircleNumber = occupiedCircles[selectedNode] {
            if gridFrame.contains(touchLocation) {
                selectedNode.position = touchLocation
            }
        } else {
            selectedNode.position = touchLocation
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        if isTouchingResetButton {
            for node in touchedNodes {
                if node.name == "resetButton" {
                    resetGame()
                    break
                }
            }
            isTouchingResetButton = false
        } else if let selectedNode = selectedNode {
            selectedNode.zPosition = 0
            self.selectedNode = nil

            var droppedOnCircleNumber: Int? = nil
            var movedToValidCircle = false

            if let currentCircleNumber = occupiedCircles[selectedNode] {
                if let possibleMoves = pathRules[currentCircleNumber] {
                    for node in touchedNodes {
                        if let circle = node as? SKShapeNode, let circleName = circle.name, circleName.starts(with: "numberedCircle-"),
                           let targetNumber = Int(circleName.components(separatedBy: "-").last!), possibleMoves.contains(targetNumber),
                           !occupiedCircles.values.contains(targetNumber) || occupiedCircles[selectedNode] == targetNumber {

                            let moveAction = SKAction.move(to: circle.position, duration: 0.2)
                            selectedNode.run(moveAction)
                            occupiedCircles[selectedNode] = targetNumber
                            droppedOnCircleNumber = targetNumber
                            movedToValidCircle = true
                            break
                        }
                    }
                    if !movedToValidCircle {
                        if let targetCircle = circleNodes[currentCircleNumber] {
                            let moveAction = SKAction.move(to: targetCircle.position, duration: 0.2)
                            selectedNode.run(moveAction)
                        }
                    }
                }
            } else {
                for node in touchedNodes {
                    if let circle = node as? SKShapeNode, let circleName = circle.name, circleName.starts(with: "numberedCircle-"),
                       let number = Int(circleName.components(separatedBy: "-").last!), !occupiedCircles.values.contains(number) {
                        let moveAction = SKAction.move(to: circle.position, duration: 0.2)
                        selectedNode.run(moveAction)
                        occupiedCircles[selectedNode] = number
                        droppedOnCircleNumber = number
                        break
                    }
                }
                if droppedOnCircleNumber == nil, let initialPosition = initialStonePositions[selectedNode] {
                    let moveAction = SKAction.move(to: initialPosition, duration: 0.2)
                    selectedNode.run(moveAction)
                }
            }
            previousPosition = nil
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode?.zPosition = 0
        selectedNode = nil
        isTouchingResetButton = false
        if let previousPosition = previousPosition, let selectedNode = selectedNode {
            let moveAction = SKAction.move(to: previousPosition, duration: 0.2)
            selectedNode.run(moveAction)
        }
        self.previousPosition = nil
    }
}
