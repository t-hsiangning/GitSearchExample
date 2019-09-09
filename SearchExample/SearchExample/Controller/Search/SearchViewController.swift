//
//  SearchViewController.swift
//  SearchExample
//
//  Created by t-hsiangning on 2019/09/02.
//  Copyright © 2019 t-hsiangning. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewModel()
    }
}

extension SearchViewController {
    func setUpViewModel() {
        
        self.searchBar.rx.text
            .subscribe(onNext: { [weak self] keyWord in
                guard let sSelf = self else { return }
                sSelf.viewModel.keyWords.accept(keyWord ?? "")
            }).disposed(by: self.disposeBag)
        
        self.viewModel.results.bind(to: self.tableView.rx.items(cellIdentifier: "SearchTableViewCell", cellType: SearchTableViewCell.self)) { (row, element, cell) in
            cell.viewModel = element
            cell.resultTitle.text = element.fullName
        }.disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .withLatestFrom(self.viewModel.results) { (indexPath, results) in
                return (indexPath, results)
            }
            .subscribe(onNext: { [weak self] element in
                guard let sSelf = self else { return }
                let row = element.0.row
                let results = element.1
                sSelf.tableView.deselectRow(at: element.0, animated: true)
                let urlString = results[row].htmlUrl
                guard let url = URL(string: urlString) else { return }
                let safariViewController = SFSafariViewController(url: url)
            sSelf.present(safariViewController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
}
