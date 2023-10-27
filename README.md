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

All you need is an `API` and an `APIRequest` and you're done! You can go take a nap!

```swift
public protocol API {
    var baseUrl: String { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var middlewares: [Middleware]? { get }
    var defaults: RequestDefaults? { get }
}

public protocol APIRequest {
    associatedtype Body: Encodable = EmptyBody
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var body: Body { get }
}
```

## SwiftUI Bindings

RestySwift also exposes SwiftUI bindings which are essentially self contained observable view models to bind your requests directly to the data model. After instantiation the request will automatically be performed in the background and the result of the request will be available via the `wrappedValue` of the request object. The data type of the request object is determined and enforced by the `BindingRequest.Response` type. Additionally errors and the ability to manually perform the request are exposed via the `projectedValue` of the Request. See example below.

### SwiftUI Example

```swift
struct DogRequest: BindingRequest {
    var api: API { TestApi() }
    typealias Body = EmptyBody
    typealias Response = Dog
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/dog" }
    var body: EmptyBody? { nil }
}

struct DogView: View {

    @Request(DogRequest()) var dog: Dog?

    var body: some View {
        VStack {
            if $dog.error != nil {
                Text("Unable to load dog")
            }
            if let dog = dog {
                Text(dog.name)
                Button {
                    $dog.performRequest()
                } label: {
                    Text("Refresh")
                }
            } else {
                ProgressView()
            }
        }
    }
}
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/chrispflepsen/RestySwift.git")
]
```
