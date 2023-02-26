//
//  NetworkManager.swift
//  Gbooks
//
//  Created by Swaminarayan on 26/02/23.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    private var key = "AIzaSyB6IqVYNCIBKQ5qdcWHwmV3zLkJVdEltk4"
    
    let header = HTTPHeader(name:"Content-Type", value: "application/json")

    func getData<T: Decodable>(url: String, parameter: Parameters?, model: T.Type, completion: @escaping (T) -> Void, failure: @escaping (AFError) -> Void) -> DataRequest?{
        var finalURL = url
        var param = parameter
        param?["key"] = key
        if !(param?.isEmpty ?? true), !url.contains("?") {
            if let queryParam = param?.queryString() {
                finalURL = finalURL + "?" + (queryParam.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
                param = [:]
            }
        }

        return AF.request(finalURL, method: .get, encoding: URLEncoding.queryString, headers: [header])
            .validate()
            .responseDecodable(of:T.self) { dataReturn in
                switch dataReturn.result{
                case let .success(result):
                    completion(result)
                case let .failure(error):
                    failure(error)
                }
            }
            
        }
}
