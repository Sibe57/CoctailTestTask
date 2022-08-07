//
//  SearchViewProtocol.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 07.08.2022.
//

import Foundation


protocol SearchViewProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    func update()
    func update(with error: String)
    func changeAtrivityIndicatorState(toStartAnimating: Bool)
    func selfBlur()
    func selfUnblur()
}
