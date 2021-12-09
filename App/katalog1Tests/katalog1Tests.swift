//
//  katalog1Tests.swift
//  katalog1Tests
//
//  Created by ryco mitrais on 06/12/21.
//

import XCTest

class Katalog1Tests: XCTestCase {
    var urlSession: URLSession!
    override func setUpWithError() throws {
        try super.setUpWithError()
        urlSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        urlSession = nil
        try super.tearDownWithError()
    }
    func testValidApiCall() throws {
        let urlString = "https://api.rawg.io/api"
        let apiKey = "61c55e29789040f4a2d54e5aa44a6031"
        let url = URL(string: "\(urlString)/games?key=\(apiKey)")!
        let promise = expectation(description: "Status code will be 200")
        let dataTask = urlSession.dataTask(with: url) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code : \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }

}
