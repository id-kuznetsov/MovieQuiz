//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 12.08.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func buttonState(isEnabled: Bool)
    
    func showQuizResult()
    
    func showNetworkError(message: String)
}
