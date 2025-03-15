//
//  EpisodeCellViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 10.03.2025.
//

import Foundation
import UIKit

protocol EpisodeDataRender{
    var name : String { get }
    var air_date : String { get }
    var episode : String { get }
}

final class EpisodeCellViewModel : Equatable {
    private let episodeUrl : URL?
    private var isFetchingEpisode : Bool = false
    private var dataBlock : ((EpisodeDataRender)->Void)?
    
    public let borderColor : UIColor
    public var episode : EpisodeModel?{
        didSet{
            guard let model = episode else {return}
            dataBlock?(model)
        }
    }
    

    public func registerforData(_ block: @escaping (EpisodeDataRender)->Void){
        self.dataBlock = block
    }
    
    init(episodeUrl: URL?,borderColor : UIColor = .systemBlue) {
        self.episodeUrl = episodeUrl
        self.borderColor = borderColor
    }
    
    public func fetchEpisode(){
        guard !isFetchingEpisode else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
       

        guard let url = episodeUrl,
              let request =
                RequestManager(url: url) else {return }
        
        isFetchingEpisode = true
        ServiceManager.shared.execute(request, expecting: EpisodeModel.self){
            [weak self] result in
                switch result{
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.episode = model
                    }
                case .failure(let failure):
                    print(failure)
                }
            
        }
    }
    
    static func == (lhs: EpisodeCellViewModel, rhs: EpisodeCellViewModel) -> Bool {
        return lhs.episodeUrl == rhs.episodeUrl
    }
}
