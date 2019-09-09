//
//  APIManager.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/03.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class APIManager {
    static let baseURL = "https://api.github.com"
    static let path = "/search/repositories"

    static func get(keyWord: String, completion: @escaping(APIResult) -> Void) {
        if keyWord.isEmpty { return }
        let getURL = "\(baseURL)\(path)"
        let patameters:[String: Any] = ["q": keyWord]
        let headers: HTTPHeaders = ["Accept": "application/json", "Accept-Encoding": "gzip"]
        Alamofire.request(getURL, method: .get, parameters: patameters, encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal), headers: headers).responseJSON(completionHandler: { (response) in
            if let error = response.error {
                print(error)
                completion(APIResult.error(error))
            } else {
                guard let data = response.data else { return }
                do {
                    let responseJSON = try JSON(data: data)
                    completion(APIResult.success(responseJSON))
                } catch let error {
                    print(error)
                    completion(APIResult.error(error))
                }
            }
        })
    }
}

enum APIResult {
    case success(JSON)
    case error(Error)
}

struct ErrorResponse: Error, CustomStringConvertible {
    var description: String
}



