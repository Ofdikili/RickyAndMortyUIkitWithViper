//
//  ImageLoader.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import Foundation

class ImageLoader{
    static let shared = ImageLoader()
 
    private var cache = NSCache<NSString, NSData>()
    
    private init(){}
    
    
     func getImage(imageUrl : URL,completion : @escaping (Result<Data,Error>) ->Void){
        let urlString = NSString(string: imageUrl.absoluteString)
        if let cachedImageData = cache.object(forKey: urlString) as? Data {
            completion(.success(cachedImageData))
            return
        }else{
            let task =  URLSession.shared.dataTask(with: imageUrl){
                (data,_,error) in
                    if error != nil {
                           completion(.failure(ServiceFailures.invalidRequest))
                           return
                       }
                       guard let data else {
                           completion(.failure(ServiceFailures.noData))
                           return
                       }
                self.cache.setObject(data as NSData, forKey: urlString)
                    completion(.success(data))
            }
            task.resume()
        }
        
        
       
    }
}
