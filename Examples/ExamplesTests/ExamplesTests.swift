//
//  ExamplesTests.swift
//  ExamplesTests
//
//  Created by xaoxuu on 2023/8/6.
//

import XCTest
@testable import Examples

final class ExamplesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let str = "abcdefg"
        let str1 = str[location: 0, length: 2]
        let str2 = str[2..<3]
        let str3 = str[2...3]
        print("str1:", str1)
        print("str2:", str2)
        print("str3:", str3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
