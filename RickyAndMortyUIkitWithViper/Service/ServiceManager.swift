//
//  ServiceManager.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation

enum ServiceFailures : Error {
    case badUrl
    case invalidRequest
    case noData
    case decodingFailure
}

final class ServiceManager {
    static let shared = ServiceManager()
    
    private let cacheManager = APICacheManager()
    private init() {}
    
    public func execute<T : Codable>(_ request:RequestManager,
                                     expecting returningType: T.Type ,
    completion : @escaping (Result<T,Error>) ->Void
    ){
        if let cachedData = cacheManager.cachedResponse(for: request.endPoint, url: request.url){
            do {
                let result = try JSONDecoder().decode(returningType.self, from: cachedData)
                print("geted cached api response")
                completion(.success(result))
            } catch  {
                completion(.failure(error))
            }
            return
        }
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceFailures.badUrl))
            return
        }
     let task =  URLSession.shared.dataTask(with: urlRequest){
         [weak self] (data,_,error) in
         if error != nil {
                completion(.failure(ServiceFailures.invalidRequest))
                return
            }
            guard let data else {
                completion(.failure(ServiceFailures.noData))
                return
            }
            do{
                let decodingData = try JSONDecoder().decode(returningType.self, from: data)
                self?.cacheManager.setCache(for: request.endPoint, url: request.url, data: data)
                print("geted network api response")
                completion(.success(decodingData))
            }catch{
                completion(.failure(ServiceFailures.decodingFailure))
                return
            }
        }
        task.resume()
    }
    
    private func request(from request : RequestManager) -> URLRequest? {
           guard let url = request.url else {return nil}
           var request = URLRequest(url: url)
           request.httpMethod = request.httpMethod
           return request
       }
}
