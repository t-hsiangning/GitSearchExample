//
//  SearchTableViewCell.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/02.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var resultTitle: UILabel!
    
    var viewModel: GithubRepoModel = GithubRepoModelImpl()
}
