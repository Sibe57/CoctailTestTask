//
//  CoctailSearchIteractor.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getCoctails()
}

class CoctailSearchIteractor: AnyInteractor {
    
    var presenter: AnyPresenter?
    
    func getCoctails(relevantTo search: String) -> [Coctail]? {
        var coctails: [Coctail]?
        NetwotkManager.fetchData(searchString: search) {
            coctails = $0
        }
        return coctails
    }
    func getCoctails() {
        
    }
}
