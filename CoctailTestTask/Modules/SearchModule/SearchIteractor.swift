//
//  CoctailSearchIteractor.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation

protocol SearchInteractor {
    var presenter: SearchPresenterProtocol? { get set }
    func getCoctails(searchString: String)
}

class SearchIteractor: SearchInteractor {
    
    var presenter: SearchPresenterProtocol?
    
    func getCoctails(searchString: String) {
        NetwotkManager.fetchData(searchString: searchString) {
            self.presenter?.interactorDoneWithCoctails(coctails: $0)
        }
    }
}
