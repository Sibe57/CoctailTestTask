//
//  DetailPresenter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 06.08.2022.
//

import Foundation

protocol DetailPresenterProtocol {
    var view: DetailViewProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    
    var coctailToPresent: Coctail? { get set }
    func getTitleName() -> String
    func getImageURL() -> URL?
    func viewWillDissmis()
}

final class DetailPresenter: DetailPresenterProtocol {
    
    var view: DetailViewProtocol?
    var router: SearchRouterProtocol?
    
    var coctailToPresent: Coctail?
    
    init() {}
    
    func getTitleName() -> String {
        guard let coctailToPresent = coctailToPresent else { return "" }
        return coctailToPresent.strDrink
    }
    
    func getImageURL() -> URL? {
        guard let coctailToPresent = coctailToPresent else { return nil }

        return URL(string: coctailToPresent.strDrinkThumb.replacingOccurrences(
            of: "\\", with: ""
        ))
    }
    
    func viewWillDissmis() {
        router?.returnToSearchScreen()
    }
    
    
    
}
