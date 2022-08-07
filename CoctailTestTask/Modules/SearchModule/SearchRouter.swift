//
//  CoctailRouter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

typealias EntryPoint = SearchViewProtocol & ASDKViewController<ASDisplayNode>


final class SearchRouter: SearchRouterProtocol {
    
    var entry: EntryPoint?
    var transitionHandler: ASDKViewController<ASDisplayNode>?
    var searchPresenter: SearchPresenterProtocol?
    var detailView: DetailViewProtocol?
    var detailPresenter: DetailPresenterProtocol?
    
    // MARK: Trasitions
    
    func toDetailScreen(about coctail: Coctail) {
        assemblyDetailModule()
        guard let detailVC = detailView as? DetailViewController else { return }
        
        detailPresenter?.coctailToPresent = coctail
    
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .coverVertical
        
        transitionHandler?.present(detailVC, animated: true)
    }
    
    func returnToSearchScreen() {
        searchPresenter?.showSearchView()
    }
    
    
// MARK: Modyle Assembler
    
    func assemblySearchModule() {
        searchPresenter = SearchPresenter()
        
        var searchView: SearchViewProtocol = SearchViewController()
        var searchIteractor: SearchInteractorProtocol = SearchIteractor()
        
        transitionHandler = searchView as? SearchViewController
        self.entry = searchView as? EntryPoint
        
        searchView.presenter = searchPresenter
        searchIteractor.presenter = searchPresenter
        searchPresenter?.router = self
        searchPresenter?.view = searchView
        searchPresenter?.interactor = searchIteractor
    }
    
    func assemblyDetailModule() {
        detailView = DetailViewController()
        detailPresenter = DetailPresenter()
        detailView?.detailPresenter = detailPresenter
        detailPresenter?.view = detailView
        detailPresenter?.router = self
    }
}

