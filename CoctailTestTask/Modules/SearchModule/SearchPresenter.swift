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
    var coctails: [Coctail] = []
    
    // MARK: Network reqests
    
    func textFieldDidChange(text: String?) {
        
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        guard let text = text else {
            view?.update(with: "EmptyTextField")
            view?.changeAtrivityIndicatorState(toStartAnimating: false)
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
        view?.changeAtrivityIndicatorState(toStartAnimating: true)
    }
    
    func interactorDoneWithCoctails(coctails: [Coctail]?) {
        if let coctails = coctails {
            self.coctails = coctails
            view?.update()
        } else {
            view?.update(with: "data fetching error")
        }
        view?.changeAtrivityIndicatorState(toStartAnimating: false)
    }
    
    // MARK: CollectionViewSetup
    
    func getCoctail(at index: Int) -> Coctail? {
        guard coctails.count > index else { return nil }
        return coctails[index]
    }
    
    func getCoctailsCount() -> Int {
        coctails.count
    }
    
    // MARK: Transitions
    
    func cellDidTapped(with index: Int) {
        view?.selfBlur()
        router?.toDetailScreen(about: coctails[index])
    }
    
    func showSearchView() {
        view?.selfUnblur()
    }
}
