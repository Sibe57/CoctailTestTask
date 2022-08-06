//
//  CoctailRouter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import AsyncDisplayKit

typealias EntryPoint = SearchViewProtocol & ASDKViewController<ASDisplayNode>

protocol SearchRouterProtocol {
    var entry: EntryPoint? { get }
    func assemblySearchModule()
    func toDetailScreen(about coctail: Coctail)
    func returnToSearchScreen()
}

final class SearchRouter: SearchRouterProtocol {
    
    var entry: EntryPoint?
    var transitionHandler: ASDKViewController<ASDisplayNode>?
    var searchPresenter: SearchPresenterProtocol?
    var detailView: DetailViewProtocol?
    var detailPresenter: DetailPresenterProtocol?
    
    
    //We can divite this func to Assembly class but this app quite small
    func assemblySearchModule() {
        
        searchPresenter = SearchPresenter()
        
        var searchView: SearchViewProtocol = SearchViewController()
        var searchIteractor: SearchInteractor = SearchIteractor()
        
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
}

