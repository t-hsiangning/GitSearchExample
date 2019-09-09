//
//  BaseAPIProtocol.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/03.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseAPIProtocol {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseURL: URL { get }
    var headers: HTTPHeaders { get }
    
}
extension BaseAPIProtocol {
    var baseURL: URL {
        let baseURLString: String = "https://api.github.com"
        return try! baseURLString.asURL()
    }
    
}
protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = TimeInterval(30.0)
        if let param = parameters {
            urlRequest = try encoding.encode(urlRequest, with: param)
        }
        
        return urlRequest
    }
}
