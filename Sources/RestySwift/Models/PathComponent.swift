//
//  PathComponent.swift
//  
//
//  Created by Chris Pflepsen on 3/15/23.
//

import Foundation

@propertyWrapper struct LeadingSlash {
    private var value: String? = nil
    var wrappedValue: String? {
        get { value }
        set {
            guard let component = newValue else {
                value = nil
                return
            }
            guard component.hasPrefix("/") else {
                value = "/" + component
                return
            }
            value = component
        }
    }

    var projectedValue: String {
        value ?? ""
    }
}

struct PathComponent {

    @LeadingSlash var path: String?

    init(_ path: String?) {
        self.path = path
    }

    static func +(lhs: PathComponent, rhs: PathComponent) -> PathComponent {
        return PathComponent((lhs.path ?? "") + (rhs.path ?? ""))
    }
}

//public protocol CustomRequest {
//    associatedtype Response: Decodable
//}
//
//@propertyWrapper public struct ObservableRequest {
//    private var value: some Responsable
//    public var wrappedValue: some Responsable {
//        get { value }
//        set { value = newValue }
//    }
//
//    public var projectedValue: String {
//        ""
//    }
//
//    public func update() {
//
//    }
//}


import SwiftUI

struct DogProvider: SessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let indy = Dog(name: "Indy", age: 3, breed: "Golden")
        let data = (try? JSONEncoder().encode(indy)) ?? Data()
        return (data, urlResponse(request: request))
    }

    func upload(for request: URLRequest, from: Data) async throws -> (Data, URLResponse) {
        throw APIError.unknown
    }

    func urlResponse(request: URLRequest, statusCode: HTTPStatus = .success) -> URLResponse {
        HTTPURLResponse(url: request.url!,
                        statusCode: statusCode.statusCode,
                        httpVersion: nil,
                        headerFields: nil)! as URLResponse
    }
}

struct DogAPI: API {
    var baseUrl: String = "dogs.test"
    var headers = [String:String]()
    var encoder = JSONEncoder()
    var decoder = JSONDecoder()
    var sessionProvider: SessionProvider = SeriesProvider(series: .multiple([
        .success(Dog(name: "Tazo", age: 10, breed: "Chocolate Lab")),
        .success(Dog(name: "Indy", age: 3, breed: "Golden"))
    ]))
}

struct Dog: Codable {
    let name: String
    let age: Int
    let breed: String
}

public protocol Responsable {
    associatedtype Response: Decodable
}

extension Dog: Responsable {
    typealias Response = Dog
}

struct DogRequest: APIRequest {
    typealias Body = EmptyBody
    var body: EmptyBody?
    var httpMethod: HTTPMethod = .GET
    var path: String = "/dog"
    typealias Response = Dog
}

//@propertyWrapper struct Response<T: APIRequest> {
//    private var request: any APIRequest
//    var wrappedValue: T.Response?
//
//    public var projectedValue: Published<T.Response?> {
//        Published(initialValue: .none)
////        return .constant(nil)
////        return nil
//    }
//
//    public init(_ request: some APIRequest) {
//        self.request = request
////        self.wrappedValue = T.Response
//    }
//
//    public func update() {
//
//    }
//
//    private func performRequest(client: APIClient) async throws {
//        let result = try await client.perform(request: request)
//
//    }
//}

//@propertyWrapper struct Paging<T: Responsable> {
//    var wrappedValue: T
//
//    public var projectedValue: Binding<T.Response?> {
//        return .constant(nil)
////        return nil
//    }
//
//    var currentPage: Int { 42 }
//
//    public func nextPage() {
//
//    }
//}

@propertyWrapper
class Resty<U: API, T: APIRequest> {
//    private var _wrappedValue: T.Response?
    var wrappedValue: T.Response?
    private let request: T
    private let api: U

    init(_ api: U, _ request: T) {
        self.request = request
        self.api = api
        update()
    }

    public func update() {
        Task {
            try? await performRequest()
        }
    }

    private func performRequest() async throws {
        let result = try await api.perform(request: request)
        wrappedValue = result
    }
}


//extension Response {
//    convenience init<T: APIRequest>(_ request: T) {
//        self.init(DogAPI(), request)
//    }
//}

struct DogView: View {

    @Resty(DogAPI(), DogRequest())
    var dog: Dog?

//    @Response(<#T##api: _##_#>, <#T##request: _##_#>)

//    @Paging var doggie: DogRequest

    var body: some View {
        Spacer()
        if let dog = dog {
            Text(dog.name)
        } else {
            Text("Loading")
        }
        Spacer()
        Button {
//            $dog.update()
        } label: {
            Text("Reload")
        }
    }
}

//@propertyWrapper
//struct APIRequestWrapper<Request: APIRequest> {
//    var request: Request
//
//    var wrappedValue: Request.Response? {
//        get { request.response }
//        set { request.response = newValue }
//    }
//
//    init(wrappedValue: Request.Response? = nil) {
//        self.request = Request()
//        self.wrappedValue = wrappedValue
//    }
//}
