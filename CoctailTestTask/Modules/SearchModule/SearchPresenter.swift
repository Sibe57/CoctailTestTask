//
//  CoctailSearchPresenter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation


final class SearchPresenter: SearchPresenterProtocol {
    
    var router: SearchRouterProtocol?
    var interactor: SearchInteractorProtocol?
    var view: SearchViewProtocol?
    
    var searchTimer: Timer?
    var searchString: String!
    
    func textFieldDidChange(text: String?) {
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        guard let text = text else {
            view?.update(with: "EmptyTextField")
            view?.changeAtrivitiIndicatorState(toStartAnimating: false)
            return
        }
        
        searchString = text.replacingOccurrences(of: " ", with: "")
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                           target: self,
                                           selector: #selector(searchText),
                                           userInfo: text, repeats: false)
        
    }
    @objc func searchText() {
        interactor?.getCoctails(searchString: searchString)
        view?.changeAtrivitiIndicatorState(toStartAnimating: true)
    }
    
    func cellDidTapped(with coctail: Coctail) {
        view?.selfBlur()
        router?.toDetailScreen(about: coctail)
    }
    
    func interactorDoneWithCoctails(coctails: [Coctail]?) {
        if let coctails = coctails {
            view?.update(with: coctails)
        } else {
            view?.update(with: "data fetching error")
        }
        view?.changeAtrivitiIndicatorState(toStartAnimating: false)
    }
    
    func showSearchView() {
        view?.selfUnblur()
    }
}
