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
    func textFieldDidChange(text: String)
}

class CoctailSearchPresenter: AnyPresenter {
    
    func textFieldDidChange(text: String) {
        <#code#>
    }
    
    
    var router: AnyRouter?
    
    var interactor: AnyInteractor?
    
    var view: AnyView?

}
