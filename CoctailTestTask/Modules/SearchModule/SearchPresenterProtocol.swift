//
//  SearchPresenterProtocol.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 07.08.2022.
//

import Foundation


protocol SearchPresenterProtocol {
    
    var router: SearchRouterProtocol? {get set}
    var interactor: SearchInteractorProtocol? { get set }
    var view: SearchViewProtocol? { get set }
    
    func textFieldDidChange(text: String?)
    func interactorDoneWithCoctails(coctails: [Coctail]?)
    func cellDidTapped(with coctail: Coctail)
    func showSearchView()
}
