# API

A simple wrapper on top of URLSession for JSON based API(s) with support for authentication, re-authentication, versioning, and local caching via protocols

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

