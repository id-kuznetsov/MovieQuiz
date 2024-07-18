//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 16.07.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage = UserDefaults.standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let bestResult = storage.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameResult.self, from: bestResult) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                storage.set(encoded, forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    var totalAccuracy: Double {
         Double(correctAnswers) / (10 * Double(gamesCount)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        self.gamesCount += 1
        self.correctAnswers += count
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.isBestResult(bestGame) {
            bestGame = currentGame
        }
    }
    
}
