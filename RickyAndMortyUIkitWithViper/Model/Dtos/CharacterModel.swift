//
//  CharacterModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation

struct CharacterModel: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender:CharacterGender
    let origin: OriginModel
    let location: SingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
