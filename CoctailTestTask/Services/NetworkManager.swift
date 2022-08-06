//
//  NetworkManager.swift
//  CoctailTestTask
//
//  Created by Федор Еронин on 03.08.2022.
//

import Alamofire

class NetwotkManager {
    
    static func fetchData(searchString: String,
                          completion: @escaping ([Coctail]?) -> Void) {
        guard !searchString.isEmpty else {
            completion(nil)
            return
        }
        
        var result: Set<Coctail> = []
        
        var numberOfRequestsDone = 0 {
            willSet {
                if newValue == 2 {
                    completion(Array(result))
                    return
                }
            }
        }
        
        let searchByNameURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchString)"
        let searchByIngridientsURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\(searchString)"
        
        createRequest(to: searchByNameURL)
        createRequest(to: searchByIngridientsURL)
        
        func createRequest(to string: String) {
            AF.request(string)
                .responseDecodable(of: [String: Set<Coctail>?].self) { data in
                    switch data.result {
                    case .success(let value):
                        for i in value {
                            DispatchQueue.main.async {
                                if let coctails = i.value {
                                    result = result.union(coctails)
                                }
                                numberOfRequestsDone += 1
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            numberOfRequestsDone += 1
                        }
                        print(error)
                    }
                }
        }
    }
}
