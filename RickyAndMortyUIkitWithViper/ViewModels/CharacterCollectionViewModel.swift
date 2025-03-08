//
//  CharacterCollectionViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import Foundation

struct CharacterCollectionViewModel {
    let name: String
    let status: CharacterStatus
    let imageUrl: URL?
    
    init(name: String, status: CharacterStatus, imageUrl: URL?) {
        self.name = name
        self.status = status
        self.imageUrl = imageUrl
    }
    
    var statusText : String {
        switch status{
        case .alive,.dead :
            return "Status : \(status.rawValue)"
        case .unknown :
            return "Status : Unknow "
        }
    }
    
    func fetchImage(completion : @escaping (Result<Data,Error>) ->Void){
        guard let url = imageUrl else {
            completion(.failure(ServiceFailures.badUrl))
            return
        }
        ImageLoader.shared.getImage(imageUrl: url){
            result in
            switch result{
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
