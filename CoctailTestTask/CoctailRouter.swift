//
//  CoctailRouter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

typealias EntryPoint = SearchView & ASDKViewController<ASDisplayNode>

protocol SearchRouter {
    var entry: EntryPoint? { get }
    static func start() -> SearchRouter
    func toDetailScreen(about coctail: Coctail )
}

class CoctailRouter: SearchRouter {
    
    var entry: EntryPoint?
    
    static func start() -> SearchRouter {
        let router = CoctailRouter()
        
        var view: SearchView = CoctailViewController()
        var presenter: AnyPresenter = CoctailSearchPresenter()
        var iteractor: AnyInteractor = CoctailSearchIteractor()
        
        view.presenter = presenter
        iteractor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = iteractor
        router.entry = view as? EntryPoint
        
        return router
        
    }
    
    func toDetailScreen(about coctail: Coctail) {
        let detailVC = DetailViewController()
        detailVC.coctail = coctail
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .coverVertical
        print(coctail)
    }
}

