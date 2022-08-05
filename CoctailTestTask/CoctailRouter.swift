//
//  CoctailRouter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

typealias EntryPoint = SearchView & ASDKViewController<ASDisplayNode>

protocol AnyRouter {
    var entry: EntryPoint? { get }
    static func start() -> AnyRouter
}

class CoctailRouter: AnyRouter {
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
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
}

