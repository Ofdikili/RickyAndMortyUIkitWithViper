//
//  CharacterResponse.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation
struct GetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [CharacterModel]
}
