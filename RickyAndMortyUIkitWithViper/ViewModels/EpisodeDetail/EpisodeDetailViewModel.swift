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
    
    private var dataTuple : (EpisodeModel,[CharacterModel])?{
        didSet{
            delegate?.didFetchedEpisodeDetails()
        }
    }
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
    }
    
    public func fetchEpisodeData(){
        guard let url = endPointUrl,
              let request = RequestManager(url: url) else{
            return
        }
        ServiceManager.shared.execute(request, expecting: EpisodeModel.self){
           result in
            switch result{
            case .success(let episode):
                print(episode)
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
        
        var group = DispatchGroup()
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
                episode,
                characters
            )
        }
    }
}
