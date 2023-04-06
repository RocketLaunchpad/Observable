//
//  Observable.swift
//  Observable
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

/// This provides the equivalent of a private subject and a public (or internal)
/// publisher.
///
/// Instead of writing this:
///
/// ```
/// private let valueSubject: CurrentValueSubject<String, Never> = .init(“foo")
/// lazy var value: AnyPublisher<String, Never> = {
///     valueSubject.eraseToAnyPublisher()
/// }()
/// ```
///
/// You can write this:
///
/// ```
/// @Observable
/// private(set) var value: String = "foo"
/// ```
///
/// From within the declaring scope, you can write to `value` (since it was
/// declared `private(set)`. From anywhere the declaring scope is visible, you
/// can access the underlying publisher by `$value`.
///
/// This is similar to `@Published` except it will not trigger an
/// `objectWillChange` event on a containing `ObservableObject`.
///
@propertyWrapper
public struct Observable<Value> {
    private let subject: CurrentValueSubject<Value, Never>

    public init(wrappedValue initialValue: Value) {
        subject = CurrentValueSubject<Value, Never>(initialValue)
    }

    public var wrappedValue: Value {
        get {
            subject.value
        }

        set {
            subject.send(newValue)
        }
    }

    public var projectedValue: AnyPublisher<Value, Never> {
        subject.eraseToAnyPublisher()
    }
}
