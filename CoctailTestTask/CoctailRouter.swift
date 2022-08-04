//
//  CoctailRouter.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 04.08.2022.
//

import Foundation


protocol AnyRouter {
    static func start() -> AnyRouter
}

class CoctailRouter: AnyRouter {
    static func start() -> AnyRouter {
        let router = CoctailRouter()
        return router
    }
}

