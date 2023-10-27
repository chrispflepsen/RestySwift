# ``RestySwift``

A barebones protocol based package built on top of URLSession for JSON based REST API(s) with support for client middleware.

## Overview

RestySwift is a lightweight and versatile Swift library designed to simplify the process of making JSON based REST API requests. Built on top of Apple's URLSession, RestySwift offers a barebones, protocol-based approach that is both flexible and intuitive. It provides developers with the essential tools to quickly connect to a REST API with only minimal boilerplate code needed.

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

## Topics

### Creating an API and Requests

- ``API``
- ``APIRequest``
- ``RequestDefaults``

### Performing Requests

- ``API/perform(request:connector:)``

### Middleware

- ``Middleware``
- ``APIResponse``

### Stubbing Responses

- ``NetworkConnector``
- ``HTTPResponse``

### SwiftUI Bindings

- ``Request``
- ``RequestObservable``
- ``BindingRequest``

### HTTP

- ``HTTPMethod``
- ``HTTPStatus``
- ``Headers``
- ``Parameters``
- ``QueryParameter``


