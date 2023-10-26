//
//  HTTPStatus.swift
//  API
//
//  Created by Chris Pflepsen on 11/2/22.
//

import Foundation

/// HTTP status code
public enum HTTPStatus: CaseIterable {

    /// 100
    case information

    /// 101
    case switchingProtocols

    /// 200
    case success

    /// 201
    case created

    /// 202
    case accepted

    /// 203
    case nonAuthoritativeInformation

    /// 204
    case noContent

    /// 205
    case resetContent

    /// 206
    case partialContent

    /// 300
    case multipleChoices

    /// 301
    case movedPermanently

    /// 302
    case found

    /// 303
    case seeOther

    /// 304
    case notModified

    /// 307
    case temporaryRedirect

    /// 308
    case permanentRedirect

    /// 400
    case badRequest

    /// 401
    case unauthorized

    /// 403
    case forbidden

    /// 404
    case notFound

    /// 405
    case methodNotAllowed

    /// 406
    case notAcceptable

    /// 407
    case proxyAuthenticationRequired

    /// 408
    case requestTimeout

    /// 409
    case conflict

    /// 410
    case gone

    /// 411
    case lengthRequired

    /// 412
    case preconditionFailed

    /// 413
    case payloadTooLarge

    /// 414
    case uriTooLong

    /// 415
    case unsupportedMediaType

    /// 416
    case rangeNotSatisfiable

    /// 417
    case expectationFailed

    /// 418
    case imATeapot

    /// 421
    case misdirectRequest

    /// 426
    case upgradeRequired

    /// 428
    case preconditionRequired

    /// 429
    case tooManyRequests

    /// 431
    case requestHeaderFieldsTooLarge

    /// 451
    case unavailableForLegalReasons

    /// 500
    case internalServerError

    /// 501
    case notImplemented

    /// 502
    case badGateway

    /// 503
    case serviceUnavailable

    /// 504
    case gatewayTimeout

    ///  505
    case httpVersionNotSupported

    /// 506
    case variantAlsoNegotiates

    /// 510
    case notExtended

    /// 511
    case networkAuthenticationRequired

    case unknown
    
    var isSuccess: Bool {
        switch statusCode {
        case 200..<300:
            return true
        default:
            return false
        }
    }

    var statusCode: Int {
        switch self {
        case .information:
            return 100
        case .switchingProtocols:
            return 101
        case .success:
            return 200
        case .created:
            return 201
        case .accepted:
            return 202
        case .nonAuthoritativeInformation:
            return 203
        case .noContent:
            return 204
        case .resetContent:
            return 205
        case .partialContent:
            return 206
        case .multipleChoices:
            return 300
        case .movedPermanently:
            return 301
        case .found:
            return 302
        case .seeOther:
            return 303
        case .notModified:
            return 304
        case .temporaryRedirect:
            return 307
        case .permanentRedirect:
            return 308
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .methodNotAllowed:
            return 405
        case .notAcceptable:
            return 406
        case .proxyAuthenticationRequired:
            return 407
        case .requestTimeout:
            return 408
        case .conflict:
            return 409
        case .gone:
            return 410
        case .lengthRequired:
            return 411
        case .preconditionFailed:
            return 412
        case .payloadTooLarge:
            return 413
        case .uriTooLong:
            return 414
        case .unsupportedMediaType:
            return 415
        case .rangeNotSatisfiable:
            return 416
        case .expectationFailed:
            return 417
        case .imATeapot:
            return 418
        case .misdirectRequest:
            return 421
        case .upgradeRequired:
            return 426
        case .preconditionRequired:
            return 428
        case .tooManyRequests:
            return 429
        case .requestHeaderFieldsTooLarge:
            return 431
        case .unavailableForLegalReasons:
            return 451
        case .internalServerError:
            return 500
        case .notImplemented:
            return 501
        case .badGateway:
            return 502
        case .serviceUnavailable:
            return 503
        case .gatewayTimeout:
            return 504
        case .httpVersionNotSupported:
            return 505
        case .variantAlsoNegotiates:
            return 506
        case .notExtended:
            return 510
        case .networkAuthenticationRequired:
            return 511
        case .unknown:
            return -1
        }
    }
    
    init(statusCode: Int) {
        switch statusCode {
        case 100:
            self = .information
        case 101:
            self = .switchingProtocols
        case 200:
            self = .success
        case 201:
            self = .created
        case 202:
            self = .accepted
        case 203:
            self = .nonAuthoritativeInformation
        case 204:
            self = .noContent
        case 205:
            self = .resetContent
        case 206:
            self = .partialContent
        case 300:
            self = .multipleChoices
        case 301:
            self = .movedPermanently
        case 302:
            self = .found
        case 303:
            self = .seeOther
        case 304:
            self = .notModified
        case 307:
            self = .temporaryRedirect
        case 308:
            self = .permanentRedirect
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 406:
            self = .notAcceptable
        case 407:
            self = .proxyAuthenticationRequired
        case 408:
            self = .requestTimeout
        case 409:
            self = .conflict
        case 410:
            self = .gone
        case 411:
            self = .lengthRequired
        case 412:
            self = .preconditionFailed
        case 413:
            self = .payloadTooLarge
        case 414:
            self = .uriTooLong
        case 415:
            self = .unsupportedMediaType
        case 416:
            self = .rangeNotSatisfiable
        case 417:
            self = .expectationFailed
        case 418:
            self = .imATeapot
        case 421:
            self = .misdirectRequest
        case 426:
            self = .upgradeRequired
        case 428:
            self = .preconditionRequired
        case 429:
            self = .tooManyRequests
        case 431:
            self = .requestHeaderFieldsTooLarge
        case 451:
            self = .unavailableForLegalReasons
        case 500:
            self = .internalServerError
        case 501:
            self = .notImplemented
        case 502:
            self = .badGateway
        case 503:
            self = .serviceUnavailable
        case 504:
            self = .gatewayTimeout
        case 505:
            self = .httpVersionNotSupported
        case 506:
            self = .variantAlsoNegotiates
        case 510:
            self = .notExtended
        case 511:
            self = .networkAuthenticationRequired
        default:
            self = .unknown
        }
    }
}
