//
//  RepositoryNetworkModel.swift
//  RxSwiftEx4
//
//  Created by muu van duy on 2017/01/23.
//  Copyright © 2017 muuvanduy. All rights reserved.
//

import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    
    lazy var rx_repositories: Driver<[Repository]> = self.fetchRepositories()
    private var repositoryName: Observable<String>
    
    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[Repository]> {
        return repositoryName
            .subscribeOn(MainScheduler.instance) // Make sure we are on MainScheduler
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
//            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .background))
            .flatMapLatest { text in // .Background thread, network request
                return RxAlamofire
                    .json(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { error in
                        return Observable.never()
                }
            }
//            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map { json -> [Repository] in
                guard let repos = Mapper<Repository>().map(JSONObject: json) else {
                    return []
                }
                return [repos]
            }
            .observeOn(MainScheduler.instance) // switch to MainScheduler, UI updates
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: []) // This also makes sure that we are on MainScheduler
    }
}
