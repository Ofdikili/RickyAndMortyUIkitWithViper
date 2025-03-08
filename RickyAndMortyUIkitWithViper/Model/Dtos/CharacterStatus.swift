//
//  CharacterStatus.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation

enum CharacterStatus : String,Codable{
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"

        var text: String {
            switch self {
            case .alive, .dead:
                return rawValue
            case .unknown:
                return "Unknown"
            }
        }
}
