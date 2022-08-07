//
//  SearchInteractorProtocol.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 07.08.2022.
//

import Foundation


protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    func getCoctails(searchString: String)
}
