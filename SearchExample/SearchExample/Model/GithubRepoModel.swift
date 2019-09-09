//
//  GithubRepoModel.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/03.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import Foundation

protocol GithubRepoModel {
    var id: Int { get }
    var name: String { get }
    var fullName: String { get }
    var htmlUrl: String { get }
    var description: String { get }
}
struct GithubRepoModelImpl: GithubRepoModel {
    var id: Int
    var name: String
    var fullName: String
    var htmlUrl: String
    var description: String
    
    init() {
        self.id = 0
        self.name = ""
        self.fullName = ""
        self.htmlUrl = ""
        self.description = ""
    }
    
    init(id: Int, name: String, fullName: String, htmlUrl: String, desc: String) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.htmlUrl = htmlUrl
        self.description = desc
    }
}
