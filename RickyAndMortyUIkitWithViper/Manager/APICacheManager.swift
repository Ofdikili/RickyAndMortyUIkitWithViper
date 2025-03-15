//
//  APICacheManager.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 12.03.2025.
//

import Foundation
final class APICacheManager{
    static var shared = APICacheManager()
    
    private var cacheDictionary : [
        EndPoints : NSCache<NSString,NSData>
    ] = [:]
    
    private var cache = NSCache<NSString,NSData>()
    
    init(){
        setUpCache()
    }
    public func cachedResponse (for endpoint : EndPoints, url:URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint],
        let url = url
        else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache (for endpoint : EndPoints, url:URL?,data : Data){
        guard let targetCache = cacheDictionary[endpoint],
        let url = url
        else {
            return
        }
        let key = url.absoluteString as NSString
        return targetCache.setObject(data as NSData, forKey: key)
    }
    
    private func setUpCache(){
        EndPoints.allCases.forEach({
            endpoint in
            cacheDictionary[endpoint] = NSCache<NSString,NSData>()
        })
    }
}
