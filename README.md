# Observable Property Wrapper

This microframework provides a property wrapper called `@Observable` which is the equivalent of a private subject and a public (or internal) publisher.

Instead of writing this:

```swift
private let valueSubject: CurrentValueSubject<String, Never> = .init(“foo")
lazy var value: AnyPublisher<String, Never> = {
    valueSubject.eraseToAnyPublisher()
}()
```

You can write this:

```swift
@Observable
private(set) var value: String = "foo"
```

From within the declaring scope, you can write to `value` (since it was declared `private(set)`). From anywhere the declaring scope is visible, you can access the underlying publisher by `$value`.

This is similar to `@Published` except it will _not_ trigger an `objectWillChange` event on a containing `ObservableObject`.
