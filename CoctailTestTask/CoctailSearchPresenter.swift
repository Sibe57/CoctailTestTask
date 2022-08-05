//
//  CoctailSearchPresenter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation

protocol AnyPresenter {
    var router: SearchRouter? {get set}
    var interactor: AnyInteractor? { get set }
    var view: SearchView? { get set }
    func textFieldDidChange(text: String?)
    func interactorDoneWithCoctails(coctails: [Coctail]?)
    func cellDidTapped(with coctail: Coctail)
}

class CoctailSearchPresenter: AnyPresenter {
    
    var router: SearchRouter?
    var interactor: AnyInteractor?
    var view: SearchView?
    
    var searchTimer: Timer?
    var searchString: String!
    
    func textFieldDidChange(text: String?) {
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        guard let text = text else {
            self.view?.update(with: "EmptyTextField")
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
        router?.toDetailScreen(about: coctail)
    }
    
    func interactorDoneWithCoctails(coctails: [Coctail]?) {
        if let coctails = coctails {
            view?.update(with: coctails)
        } else {
            view?.update(with: "data fetching error")
        }
    }
}
