//
//  ViewController.swift
//  RxSwiftEx4
//
//  Created by muu van duy on 2017/01/23.
//  Copyright © 2017 muuvanduy. All rights reserved.
//

import UIKit
import ObjectMapper
import RxAlamofire
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar
            .rx.text
            .orEmpty
            .filter { $0.characters.count > 0 }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: rx_searchBarText)
        
        repositoryNetworkModel
            .rx_repositories
//            .drive(tableView.rx.items) { (tv, i, repository) in
//                let cell = tv.dequeueReusableCell(withIdentifier: "githubPrototypeCell", for: IndexPath(row: i, section: 0))
//                cell.textLabel?.text = "aa"
//                
//                return cell
//            }
            .drive(tableView.rx.items(cellIdentifier: "githubPrototypeCell")) { (_, result, cell) in
                cell.textLabel?.text = "adasdad"
            }
//            .drive(tableView.rx_itemsWithCellFactory) {
//                (tv, i, repository) in
//                let indexPath = IndexPath(row: i, section: 0)
//                let cell = tv.dequeueReusableCellWithIdentifier("githubPrototypeCell", for: indexPath)
//                cell.viewModel = repository
//                return cell as UITableViewCell
//            }
            .addDisposableTo(disposeBag)

        
//        repositoryNetworkModel
//            .rx_repositories
////            .drive(onNext: <#T##(([Repository]) -> Void)?##(([Repository]) -> Void)?##([Repository]) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//            .drive(onNext: { repositories in
//                if repositories.count == 0 {
//                    let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            })
//            .addDisposableTo(disposeBag)
    }
}

