//
//  PhotoCellViewModels.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 10.03.2025.
//

import Foundation

struct PhotoCellViewModels{
    let url : URL?
    
    init(url: URL) {
        self.url = url
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoader.shared.getImage(imageUrl : imageUrl, completion: completion)
    }
    
}
