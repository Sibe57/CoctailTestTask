//
//  SearchRouterProtocol.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 07.08.2022.
//

import Foundation


protocol SearchRouterProtocol {
    var entry: EntryPoint? { get }
    func assemblySearchModule()
    func toDetailScreen(about coctail: Coctail)
    func returnToSearchScreen()
}
