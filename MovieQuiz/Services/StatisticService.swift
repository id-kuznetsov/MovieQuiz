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
            return .init(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
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
