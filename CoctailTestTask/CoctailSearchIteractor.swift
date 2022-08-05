//
//  CoctailSearchIteractor.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    func getCoctails(searchString: String)
}

class CoctailSearchIteractor: AnyInteractor {
    
    var presenter: AnyPresenter?
    
    func getCoctails(searchString: String) {
        NetwotkManager.fetchData(searchString: searchString) {
            self.presenter?.interactorDoneWithCoctails(coctails: $0)
        }
    }
}
