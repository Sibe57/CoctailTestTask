//
//  DetailPresenterProtocol.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 07.08.2022.
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
