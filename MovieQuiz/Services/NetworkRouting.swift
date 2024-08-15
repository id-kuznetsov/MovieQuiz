//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Илья Кузнецов on 10.08.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
