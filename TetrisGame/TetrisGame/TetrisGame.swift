//
//  TetrisGame.swift
//  TetrisGame
//
//  Created by Natalia on 12.09.24.
//
import SwiftUI

enum ShapeType {
    case I, O, T, S, Z, J, L
}

struct Block {
    let shape: ShapeType
    let color: Color
    var coordinates: [(Int, Int)]
}

class TetrisGame: ObservableObject {
    @Published var grid: [[Color]]
    @Published var currentBlock: Block?
    @Published var gameOver = false
    
    let rows = 20
    let columns = 10
    let blockSize: CGFloat = 30
    private var timer: Timer?
    
    init() {
        self.grid = Array(repeating: Array(repeating: Color.clear, count: columns), count: rows)
        self.currentBlock = self.generateBlock()
        startGameLoop()
    }
    
    func generateBlock() -> Block {
        let shapes: [ShapeType] = [.I, .O, .T, .S, .Z, .J, .L]
        let shape = shapes.randomElement()!
        let color: Color = {
            switch shape {
            case .I: return .cyan
            case .O: return .yellow
            case .T: return .purple
            case .S: return .green
            case .Z: return .red
            case .J: return .blue
            case .L: return .orange
            }
        }()
        
        let coordinates: [(Int, Int)] = {
            switch shape {
            case .I: return [(0,4), (0,5), (0,6), (0,7)]
            case .O: return [(0,4), (0,5), (1,4), (1,5)]
            case .T: return [(0,4), (1,3), (1,4), (1,5)]
            case .S: return [(0,5), (0,6), (1,4), (1,5)]
            case .Z: return [(0,4), (0,5), (1,5), (1,6)]
            case .J: return [(0,4), (1,4), (1,5), (1,6)]
            case .L: return [(0,6), (1,4), (1,5), (1,6)]
            }
        }()
        
        return Block(shape: shape, color: color, coordinates: coordinates)
    }
    
    func moveBlockDown() {
        guard let block = currentBlock else { return }
        let newCoordinates = block.coordinates.map { ($0.0 + 1, $0.1) }
        
        if canMove(to: newCoordinates) {
            currentBlock?.coordinates = newCoordinates
        } else {
            placeBlock()
            if !gameOver {
                currentBlock = generateBlock()
                if !canMove(to: currentBlock!.coordinates) {
                    gameOver = true
                }
            }
        }
    }
    
    func moveBlockLeft() {
        guard let block = currentBlock else { return }
        let newCoordinates = block.coordinates.map { ($0.0, $0.1 - 1) }
        
        if canMove(to: newCoordinates) {
            currentBlock?.coordinates = newCoordinates
        }
    }
    
    func moveBlockRight() {
        guard let block = currentBlock else { return }
        let newCoordinates = block.coordinates.map { ($0.0, $0.1 + 1) }
        
        if canMove(to: newCoordinates) {
            currentBlock?.coordinates = newCoordinates
        }
    }
    
    func rotateBlock() {
        guard let block = currentBlock else { return }
        let newCoordinates = rotateShape(block.shape, coordinates: block.coordinates)
        if canMove(to: newCoordinates) {
            currentBlock?.coordinates = newCoordinates
        }
    }
    
    private func rotateShape(_ shape: ShapeType, coordinates: [(Int, Int)]) -> [(Int, Int)] {
        let center = coordinates[1]
        return coordinates.map { (row, col) in
            let r = row - center.0
            let c = col - center.1
            return (center.0 - c, center.1 + r)
        }
    }
    
    private func canMove(to coordinates: [(Int, Int)]) -> Bool {
        for (row, col) in coordinates {
            if row < 0 || row >= rows || col < 0 || col >= columns || grid[row][col] != Color.clear {
                return false
            }
        }
        return true
    }
    
    private func placeBlock() {
        guard let block = currentBlock else { return }
        for (row, col) in block.coordinates {
            grid[row][col] = block.color
        }
        clearLines()
    }
    
    private func clearLines() {
        for row in (0..<rows).reversed() {
            if grid[row].allSatisfy({ $0 != Color.clear }) {
                for r in (1...row).reversed() {
                    grid[r] = grid[r-1]
                }
                grid[0] = Array(repeating: Color.clear, count: columns)
            }
        }
    }
    
    private func startGameLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if !self.gameOver {
                self.moveBlockDown()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
