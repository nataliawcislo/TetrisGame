//
//  ContentView.swift
//  TetrisGame
//
//  Created by Natalia on 12.09.24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var game = TetrisGame()
    
    let gridSize: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                GridView(grid: game.grid, gridSize: gridSize, currentBlock: game.currentBlock)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.8)
                    .border(Color.black)
                
                Spacer()
                
                if game.gameOver {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                } else {
                    HStack(spacing: 20) {
                        Button(action: {
                            game.moveBlockLeft()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            game.rotateBlock()
                        }) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            game.moveBlockDown()
                        }) {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                        
                        Button(action: {
                            game.moveBlockRight()
                        }) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GridView: View {
    let grid: [[Color]]
    let gridSize: CGFloat
    let currentBlock: Block?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<grid.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<grid[row].count, id: \.self) { column in
                            Rectangle()
                                .fill(grid[row][column])
                                .frame(width: gridSize, height: gridSize)
                                .border(Color.black, width: 0.5)
                                .overlay(
                                    currentBlock != nil && currentBlock!.coordinates.contains(where: { $0.0 == row && $0.1 == column }) ?
                                        Rectangle().fill(currentBlock!.color).opacity(0.5) :
                                        nil
                                )
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .animation(.easeInOut(duration: 0.5), value: grid)
        }
    }
}
