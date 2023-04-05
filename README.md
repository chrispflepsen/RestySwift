# RestySwift💤

A protocol based barebones wrapper on top of URLSession for JSON based REST API(s) with support for authentication, authentication refresh, versioning, and local caching via protocols(left as an exercise to the reader of course)

## Basic Example

Define the API

```swift
import RestySwift

struct TestApi: API {
    var baseUrl: String = "http://www.api.test"
    var headers: [String : String] = [:]
    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()
}
```

Define the data structure and request

```swift
struct Dog: Codable {
    let name: String
    let breed: String
    let age: Int
}

struct DogListRequest: APIRequest {
    typealias Body = EmptyBody
    typealias Response = [Dog]
    var httpMethod: HTTPMethod { .GET }
    var path: String { "/dog" }
    var body: EmptyBody? { nil }
}
```

Perform the request

```swift
let client = APIClient(api: api)

// the `dogs` object is of type [Dog] based on the `Response` typealias of the request
let dogs = try await client.perform(request: DogListRequest())
```

All you need is an `API` and an `APIRequest` and you're done! You can go take a nap!

```swift
public protocol API {
    var baseUrl: String { get }
    var headers: [String: String] { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}

public protocol APIRequest {
    associatedtype Body: Encodable
    associatedtype Response: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: QueryParameter]? { get }
    var headers: [String: String]? { get }
    var body: Body? { get }
}
```

## SwiftUI Bindings

RestySwift also exposes SwiftUI bindings to bind your requests directly to the data model. After instantiation the request will automatically be performed in the background and the result of the request will be available via the `wrappedValue` of the request object. The data type of the request object is determined and enforced by the `BindingRequest.Response` type. Additionally errors and the ability to manually perform the request are exposed via the `projectedValue` of the Request. See example below.

### SwiftUI Example

```swift
struct DogRequest: BindingRequest {
    var api: API { TestApi() }
    typealias Body = EmptyBody
    typealias Response = Dog
    var httpMethod: HTTPMethod = .GET
    var path: String = "/dog"
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

Additionally you can easily stub any requests by passing in a `NetworkConnector` as the second parameter:

```swift
// `dog` will always be set to Porkchop
@Request(DogRequest(), .single(.success(Dog(name: "Porkchop", age: 2)))) var dog: Dog?

// Force the request to return an error
@Request(DogRequest(), .single(.error(APIError.unknown))) var dog: Dog?
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/chrispflepsen/RestySwift.git")
]
```
