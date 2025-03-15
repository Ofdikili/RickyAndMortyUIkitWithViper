//
//  EpisodeResponse.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 13.03.2025.
//

import Foundation

struct GetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [EpisodeModel]
}
