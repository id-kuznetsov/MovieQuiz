//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 16.07.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBestResult(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
