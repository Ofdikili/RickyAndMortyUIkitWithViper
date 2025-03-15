//
//  EpisodeDetailViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 13.03.2025.
//

import Foundation

protocol EpisodeDetailViewViewModelDelegate : AnyObject {
    func didFetchedEpisodeDetails()
}

class EpisodeDetailViewViewModel {
    private let endPointUrl : URL?
    
    public weak var delegate : EpisodeDetailViewViewModelDelegate?
    
    private var dataTuple : (episode : EpisodeModel,characters : [CharacterModel])?{
        didSet{
            createCellViewModels()
            delegate?.didFetchedEpisodeDetails()
        }
    }
    
    public private(set) var cellViewModels : [SectionType] = []
    
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let date = EpisodeInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created){
            createdString = EpisodeInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
            
        cellViewModels = [
            .information(viewModels:[
                .init(title:"Episode Name",value:episode.name),
                .init(title:"Air Date",value:episode.air_date),
                .init(title:"Episode",value:episode.episode),
                .init(title:"Created",value:createdString),
            ]),
            .characters(viewModels: characters.compactMap({
                character in
                return CharacterCollectionViewModel(name: character.name, status: character.status, imageUrl:URL(string:   character.image) )
            }))
        ]
    }
    
    enum SectionType{
        case information(viewModels : [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels : [CharacterCollectionViewModel])
    }
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
        
    }
    
    public func character(at index : Int)->CharacterModel?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        
        return dataTuple.characters[index]
    }
    
    public func fetchEpisodeData(){
        guard let url = endPointUrl,
              let request = RequestManager(url: url) else{
            return
        }
        ServiceManager.shared.execute(request, expecting: EpisodeModel.self){
            [weak self] result in
            switch result{
            case .success(let episode):
                self?.fetchRelatedCharacters(episode: episode)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func fetchRelatedCharacters(episode : EpisodeModel){
        //        let charactersUrls : [URL] = episode.characters.compactMap(
        //            {
        //                return URL(string: $0)
        //            }
        //        )
        //        let request : [RequestManager] = charactersUrls.compactMap({
        //            return RequestManager(url: $0)
        //        })
        let requests : [RequestManager] =
        episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RequestManager(url: $0)
        })
        
        let group = DispatchGroup()
        var characters = [CharacterModel]()
        for request in requests {
            group.enter()
            ServiceManager.shared.execute(request, expecting: CharacterModel.self){
                result in
                defer {
                    group.leave()
                }
                switch result{
                case .success(let character):
                    characters.append(character)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main){
            self.dataTuple = (
                episode : episode,
                characters : characters
            )
        }
    }
}
