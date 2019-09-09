//
//  SearchViewModel.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/03.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class SearchViewModel {
    
    public let keyWords: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    public let results: PublishSubject<[GithubRepoModel]> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init() {
        keyWords.asObservable()
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [weak self] (key) in
            guard let sSelf = self else { return }
            
            APIManager.get(keyWord: key, completion: { (result) in
                switch result {
                case .success(let resultJSON):
                    let parseResult = sSelf.parseJSON(requestJSON: resultJSON)
                    sSelf.results.onNext(parseResult)
                case .error(let errorMessage):
                    NSLog("error: \(errorMessage)")
                    sSelf.results.onNext([])
                }
            })
        }).disposed(by: self.disposeBag)
    }
    
}

extension SearchViewModel {
    private func parseJSON(requestJSON: JSON) -> [GithubRepoModel] {
        let emptyResult: [GithubRepoModel] = []
        guard let dict = requestJSON["items"].array else { return emptyResult }
        var result:[GithubRepoModel] = []
        for items in dict {
            let id: Int = items["id"].int ?? 0
            let name: String = items["name"].string ?? ""
            let fullName: String = items["full_name"].string ?? ""
            let htmlUrl: String = items["html_url"].string ?? ""
            let desc: String = items["description"].string ?? ""
            let model = GithubRepoModelImpl(id: id, name: name, fullName: fullName, htmlUrl: htmlUrl, desc: desc)
            result.append(model)
        }
        return result
    }
}
