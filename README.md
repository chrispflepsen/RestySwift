# RestySwift💤

A barebones wrapper on top of URLSession for JSON based API(s) with support for authentication, authentication refresh, versioning, and local caching via protocols

## Basic Example

Define the API

```swift
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

