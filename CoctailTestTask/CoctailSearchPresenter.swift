//
//  CoctailSearchPresenter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation

protocol AnyPresenter {
    var router: AnyRouter? {get set}
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchCoctails(with result: Result<[Coctail], Error>)
}

class CoctailSearchPresenter: AnyPresenter {
    
    var router: AnyRouter?
    
    var interactor: AnyInteractor?
    
    var view: AnyView?
    
    func interactorDidFetchCoctails(with result: Result<[Coctail], Error>) {
    }
    
    let iteractor = CoctailSearchIteractor()
    
    func getCoctails(relevantTo search: String) -> [Coctail]? {
        iteractor.getCoctails(relevantTo: search)
    }
}
