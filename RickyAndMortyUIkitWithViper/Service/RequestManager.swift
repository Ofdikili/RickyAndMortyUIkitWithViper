//
//  RequestManager.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation
final class RequestManager {
    private struct Constant {
        static let baseURL: String = "https://rickandmortyapi.com/api"
        static let characters: String = "\(baseURL)character"
        static let locations: String = "\(baseURL)location"
        static let episodes: String = "\(baseURL)episode"
    }
    public let httpMethod = "GET"

    let endPoint: EndPoints
    
    let pathComponents: [String]
    
    let queryParameters: [URLQueryItem]
    
    private var urlString: String {
         var stringURL = Constant.baseURL
        stringURL += "/"
        stringURL += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                stringURL += "/\($0)"
            })
        }

        if !queryParameters.isEmpty {
            stringURL += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            stringURL += argumentString
        }
        
        return stringURL
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endPoint: EndPoints,pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
   
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constant.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constant.baseURL+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = EndPoints(
                    rawValue: endpointString
                ) {
                    self.init(endPoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let rmEndpoint = EndPoints(rawValue: endpointString) {
                    self.init(endPoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

extension RequestManager {
    static let listCharactersRequest = RequestManager(
        endPoint: .character)
    static let listEpisodeRequest = RequestManager(
        endPoint: .episode)
}
