//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 13.07.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    func showResultAlert(_ alertModel: AlertModel)  {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion()
            }
        
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "alert"
        
        
        delegate?.showAlert(alert)
    }
   
}

