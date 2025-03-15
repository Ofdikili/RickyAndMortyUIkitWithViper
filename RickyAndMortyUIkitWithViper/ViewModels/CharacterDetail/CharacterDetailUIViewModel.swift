//
//  CharacterDetailUIViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 10.03.2025.
//

import Foundation
import UIKit

enum DetailCollectionSectionType{
    case photo (viewModel:PhotoCellViewModels)
    case info (viewModels : [InfoCellViewModel])
    case episode (viewModels : [EpisodeCellViewModel])
 
}
class CharacterDetailUIViewModel{
    public var character: CharacterModel
    
    public var episodes : [String]{
        character.episode
    }
    
    var sections : [DetailCollectionSectionType] = []
    
    init(character : CharacterModel) {
        self.character = character
        setUpSection()
    }
    
    func setUpSection(){
        self.sections = [
            .photo(viewModel: PhotoCellViewModels(url: URL(string: character.image)!)),
            .info(viewModels: [
                .init(type: .status , value: character.status.text),
                .init(type: .gender , value: character.gender.rawValue),
                .init(type: .type , value: character.type),
                .init(type: .species , value: character.species),
                .init(type: .origin , value: character.origin.name),
                .init(type: .location , value: character.location.name),
                .init(type: .created , value: character.created),
                .init(type: .episodeCount , value: "\(character.episode.count)"),
            ]),
            .episode(viewModels:
                        character.episode.compactMap({
                            return EpisodeCellViewModel(episodeUrl: URL(string: $0))
                        })
                    )
        ]
    }
    
    func createSection(_ sectionIndex : Int) -> NSCollectionLayoutSection{
        let sections = sections
        switch sections[sectionIndex]{
        case .photo:
            return createPhotoSection()
        case .info:
            return createInfoSection()
        case .episode :
            return createEpisodeSection()
        }
       
    }
    
    func createPhotoSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)),subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createInfoSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 0, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)),subitems: [item,item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createEpisodeSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150)),subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}





