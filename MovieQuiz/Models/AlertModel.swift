//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 13.07.2024.
//

import Foundation

// для алертов
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
