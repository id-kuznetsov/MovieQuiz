//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 13.07.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    func showAlert(_ alertModel: AlertModel)  {
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
        
        guard let delegate = delegate else { return }
        delegate.present(alert, animated: true)
        
        
    }
   
}

