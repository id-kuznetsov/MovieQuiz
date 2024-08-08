//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Илья Кузнецов on 08.08.2024.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        waitForExpectations(timeout: 1)
    }
    
}
