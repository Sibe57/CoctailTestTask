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
        
        var result: [Coctail] = []
        
        var numberOfRequestsDone = 0 {
            willSet {
                if newValue == 2 {
                    completion(result)
                    return
                }
            }
        }
        
        let searchByNameURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchString)"
        AF.request(searchByNameURL)
            .responseDecodable(of: [String: [Coctail]?].self) { data in
                switch data.result {
                case .success(let value):
                    for i in value {
                        DispatchQueue.main.async {
                            if let coctails = i.value {
                                result += coctails
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
        let searchByIngridientsURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\(searchString)"
        AF.request(searchByIngridientsURL)
            .responseDecodable(of: [String: [Coctail]?].self) { data in
                switch data.result {
                case .success(let value):
                    for i in value {
                        DispatchQueue.main.async {
                            if let coctails = i.value {
                                result += coctails
                            }
                            numberOfRequestsDone += 1
                        }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        numberOfRequestsDone += 1
                    }
                }
            }
    }
}


