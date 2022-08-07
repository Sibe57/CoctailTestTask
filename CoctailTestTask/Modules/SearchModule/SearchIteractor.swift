//
//  CoctailSearchIteractor.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation


final class SearchIteractor: SearchInteractorProtocol {
    
    var presenter: SearchPresenterProtocol?
    
    func getCoctails(searchString: String) {
        NetwotkManager.fetchData(searchString: searchString) {
            self.presenter?.interactorDoneWithCoctails(coctails: $0)
        }
    }
}
