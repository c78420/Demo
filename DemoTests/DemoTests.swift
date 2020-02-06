//
//  DemoTests.swift
//  DemoTests
//
//  Created by Tony Huang (黃崇漢) on 2018/5/21.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import XCTest
@testable import Demo

class DemoTests: XCTestCase {
    
    var sut: PrimeNumber!
    
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = PrimeNumber()
        
        session = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPrime() {
        let testNumber = 5
        XCTAssertEqual(sut.checkPrime(withNumber: testNumber), "\(testNumber) is prime", "TestNumber not prime")
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToiTunesGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = session.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                }
                else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
    }
    
    func testCallToiTunesCompletes() {
        // given
        let url =
            URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
