//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 12.07.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                self.delegate?.didFailToLoadData(with: error)
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomQuestion = randomQuestion(rating: rating)
            
            let question = QuizQuestion(image: imageData,
                                        text: randomQuestion.text,
                                        correctAnswer: randomQuestion.correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)

            }
        }
    }
    
    private func randomQuestion(rating: Float) -> QuestionText {
        let text: String
        let correctAnswer: Bool
        
        let questionRating = (7...9).randomElement() ?? 7
        let sign = Bool.random()
        if sign {
            text = "Рейтинг этого фильма\n больше чем \(questionRating)?"
            correctAnswer = rating > Float(questionRating)
        } else {
            text = "Рейтинг этого фильма\n меньше чем \(questionRating)?"
            correctAnswer = rating < Float(questionRating)
        }
        return QuestionText(text: text, correctAnswer: correctAnswer)
    }
}
