//
//  URLSession+Extension.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/10.
//

import Foundation

extension URLSession {
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    
    func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: handler)
        task.resume()
        
        return task
    }
    
    static func request<T: Decodable, V: Decodable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIResult?, V?) -> Void) {
        session.dataTask(endpoint) { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    
                    //statusCode 401 -> 토큰 유효기간 만료
                    if response.statusCode == 401 {
                        completion(nil, .unauthorized, nil)
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(V.self, from: data)

                        completion(nil, .invalidResponse, errorData)
                        return
                
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(T.self, from: data)
                    completion(data, .succeed, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
            
        }
    }
    
}
