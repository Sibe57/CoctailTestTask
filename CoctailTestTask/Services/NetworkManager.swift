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
        
        let strURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchString)"
        AF.request(strURL)
            .responseDecodable(of: [String: [Coctail]?].self) { data in
                switch data.result {
                case .success(let value):
                    for i in value {
                        completion(i.value)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
}


