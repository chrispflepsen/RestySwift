# RestySwift💤

A barebones protocol based package built on top of URLSession for JSON based REST API(s) with support for request and response manipulation via client middleware.

## Documentation

The full RestySwift documentation is available here: [Documentation](https://chrispflepsen.github.io/RestySwift/documentation/restyswift/)

## Basic Example

Define the API

```swift
import RestySwift

struct DogAPI: API {
    var baseUrl: String { "https://www.dog.test" }
}
```

Define the response structure and request

```swift
struct Dog: Codable {
    let name: String
    let breed: String
    let age: Int
}

struct DogListRequest: APIRequest {
    typealias Response = [Dog]
    var path: String { "/dog" }
}
```

Perform the request

```swift
let api = DogAPI()

// the `dogs` object is of type [Dog] based on the `Response` typealias of the request
let dogs = try await api.perform(request: DogListRequest())
```

All you need is an `API` and an `Request` and you're done! You can go take a nap!

```swift
public protocol API {
    var baseUrl: String { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var middleware: [Middleware]? { get }
}

public protocol Request {
    associatedtype Body: Encodable = EmptyBody
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var body: Body { get }
}
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/chrispflepsen/RestySwift.git", from: "1.0.0")
]
```
