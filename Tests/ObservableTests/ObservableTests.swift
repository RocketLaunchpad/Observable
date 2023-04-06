//
//  ObservableTests.swift
//  ObservableTests
//
//  Copyright (c) 2023 DEPT Digital Products, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Combine
import Observable
import XCTest

final class Model: ObservableObject {
    @Observable
    var property = "foo"
}

final class ObservableTests: XCTestCase {
    func testExample() throws {
        let model = Model()

        var updatedProperty: String? = nil
        var receivedObjectWillChange = false

        var cancellables = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "property publisher fired")

        model
            .objectWillChange
            .sink(receiveValue: {
                receivedObjectWillChange = true
            })
            .store(in: &cancellables)

        model.$property
            .sink(receiveValue: {
                updatedProperty = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        model.property = "bar"
        wait(for: [expectation], timeout: 0.1)

        XCTAssertFalse(receivedObjectWillChange)
        XCTAssertEqual(updatedProperty, "bar")
        XCTAssertEqual(model.property, "bar")
    }
}
