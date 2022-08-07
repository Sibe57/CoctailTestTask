//
//  NetworkManager.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import Alamofire
import Darwin

class NetwotkManager {
    
    static func fetchData(searchString: String,
                          completion: @escaping ([Coctail]?) -> Void) {
        
        var result: Set<Coctail> = []
        
        let searchByNameURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchString)"
        let searchByIngridientsURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\(searchString)"
        
        let requestGroup = DispatchGroup()
        
        let queue = DispatchQueue(label: "NetworkGroup", attributes: .concurrent)
        
        func createRequest(to string: String) {
            requestGroup.enter()
            AF.request(string)
                .responseDecodable(of: [String: Set<Coctail>?].self) { data in
                    switch data.result {
                    case .success(let value):
                        print("request")
                        for i in value {
                            if let coctails = i.value {
                                result = result.union(coctails)
                                requestGroup.leave()
                            }
                        }
                    case .failure(let error):
                        print(error)
                        requestGroup.leave()
                    }
                }
        }
        
        queue.async(group: requestGroup) {
            createRequest(to: searchByNameURL)
        }
        
        queue.async(group: requestGroup) {
            createRequest(to: searchByIngridientsURL)
        }
        requestGroup.notify(queue: .main) {
            completion(Array(result))
        }
    }
}
