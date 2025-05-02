import SpriteKit

class GameScene1: SKScene {

    var blueStones: [Stone] = []
    var redStones: [Stone] = []
    var initialStonePositions: [Stone: CGPoint] = [:]
    let stoneSize = CGSize(width: 50, height: 50)
    let gridSize = CGSize(width: 100, height: 100)
    let numRows = 3
    let numCols = 3
    var gridOrigin: CGPoint!
    var occupiedGridCells: [CGPoint: Stone] = [:]
    var selectedNode: Stone?
    var previousGridCoordinate: CGPoint?
    var resetButton: SKSpriteNode!
    var isTouchingResetButton = false // Track if touch began on the reset button

    override func didMove(to view: SKView) {
        backgroundColor = .lightGray

        // Calculate the origin to center the 3x3 grid
        let gridWidth = CGFloat(numCols) * gridSize.width
        let gridHeight = CGFloat(numRows) * gridSize.height
        gridOrigin = CGPoint(x: (size.width - gridWidth) / 2, y: (size.height - gridHeight) / 2)

        // Create blue stones on the left of the grid
        for i in 0..<3 {
            let stone = Stone(color: .blue, size: stoneSize)
            stone.name = "blueStone-\(i)"
            let initialY = size.height * 0.7 + CGFloat(i) * (stoneSize.height + 10) - (1.5 * (stoneSize.height + 10))
            stone.position = CGPoint(x: gridOrigin.x - (stoneSize.width * 1.5), y: initialY)
            blueStones.append(stone)
            initialStonePositions[stone] = stone.position
            addChild(stone)
        }

        // Create red stones on the right of the grid
        for i in 0..<3 {
            let stone = Stone(color: .red, size: stoneSize)
            stone.name = "redStone-\(i)"
            let initialY = size.height * 0.3 + CGFloat(i) * (stoneSize.height + 10) - (1.5 * (stoneSize.height + 10))
            stone.position = CGPoint(x: gridOrigin.x + gridWidth + (stoneSize.width * 1.5), y: initialY)
            redStones.append(stone)
            initialStonePositions[stone] = stone.position
            addChild(stone)
        }

        // Create the 3x3 grid (for visual reference)
        for row in 0..<numRows {
            for col in 0..<numCols {
                let gridCell = SKShapeNode(rect: CGRect(origin: CGPoint(x: gridOrigin.x + CGFloat(col) * gridSize.width, y: gridOrigin.y + CGFloat(row) * gridSize.height), size: gridSize))
                gridCell.strokeColor = .black
                gridCell.lineWidth = 1
                gridCell.zPosition = -1
                addChild(gridCell)
            }
        }

        // Create the reset button at the top right of the scene
        resetButton = SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 40))
        resetButton.position = CGPoint(x: size.width - resetButton.size.width / 2 - 20, y: size.height - resetButton.size.height / 2 - 20)
        let label = SKLabelNode(text: "Reset")
        label.fontColor = .white
        label.fontSize = 20
        label.verticalAlignmentMode = .center
        resetButton.addChild(label)
        resetButton.name = "resetButton"
//        resetButton.isUserInteractionEnabled = true
        addChild(resetButton)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        for node in touchedNodes {
            if let stone = node as? Stone {
                selectedNode = stone
                selectedNode?.zPosition = 1
                previousGridCoordinate = gridCoordinate(for: stone.position)
                break
            } else if node.name == "resetButton" {
                isTouchingResetButton = true // Mark that the touch began on the reset button
                break
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedNode = selectedNode else { return }
        let touchLocation = touch.location(in: self)
        selectedNode.position = touchLocation
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        if isTouchingResetButton {
            // Check if the touch ended on the reset button
            for node in touchedNodes {
                if node.name == "resetButton" {
                    resetGame()
                    break
                }
            }
            isTouchingResetButton = false // Reset the tracking flag
        } else if let selectedNode = selectedNode {
            selectedNode.zPosition = 0
            self.selectedNode = nil

            if let finalGridCoordinate = gridCoordinate(for: selectedNode.position) {
                if occupiedGridCells[finalGridCoordinate] == nil || occupiedGridCells[finalGridCoordinate] == selectedNode {
                    if finalGridCoordinate != previousGridCoordinate {
                        if let prevCoord = previousGridCoordinate {
                            occupiedGridCells[prevCoord] = nil
                        }
                        occupiedGridCells[finalGridCoordinate] = selectedNode
                        selectedNode.position = gridPosition(for: finalGridCoordinate)
                        print("\(selectedNode.name ?? "stone") moved to grid position: \(finalGridCoordinate)")
                    } else {
                        if let currentGridCoord = gridCoordinate(for: selectedNode.position) {
                            selectedNode.position = gridPosition(for: currentGridCoord)
                        }
                    }
                } else {
                    if let prevCoord = previousGridCoordinate {
                        selectedNode.position = gridPosition(for: prevCoord)
                        print("\(selectedNode.name ?? "stone") returned to previous position (cell occupied).")
                    }
                }
            } else {
                if let prevCoord = previousGridCoordinate {
                    selectedNode.position = gridPosition(for: prevCoord)
                    print("\(selectedNode.name ?? "stone") returned to occupying grid position (moved off grid).")
                } else if let initialPosition = initialStonePositions[selectedNode] {
                    let returnAction = SKAction.move(to: initialPosition, duration: 0.2)
                    selectedNode.run(returnAction)
                    print("\(selectedNode.name ?? "stone") returned to initial position (moved off grid, no prev coord).")
                }
            }
            previousGridCoordinate = nil
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode?.zPosition = 0
        selectedNode = nil
        isTouchingResetButton = false // Reset the tracking flag
        if let selectedNode = selectedNode, let prevCoord = previousGridCoordinate {
            selectedNode.position = gridPosition(for: prevCoord)
        } else if let selectedNode = selectedNode, let initialPosition = initialStonePositions[selectedNode] {
            let returnAction = SKAction.move(to: initialPosition, duration: 0.2)
            selectedNode.run(returnAction)
        }
        previousGridCoordinate = nil
    }

    func resetGame() {
        // Move all blue stones back to their initial positions
        for stone in blueStones {
            if let initialPosition = initialStonePositions[stone] {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.3)
                stone.run(moveAction)
            }
        }

        // Move all red stones back to their initial positions
        for stone in redStones {
            if let initialPosition = initialStonePositions[stone] {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.3)
                stone.run(moveAction)
            }
        }

        // Clear the occupied grid cells
        occupiedGridCells.removeAll()

        print("Game reset.")
    }
}

class Stone: SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    convenience init(color: UIColor, size: CGSize) {
        self.init(texture: nil, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

