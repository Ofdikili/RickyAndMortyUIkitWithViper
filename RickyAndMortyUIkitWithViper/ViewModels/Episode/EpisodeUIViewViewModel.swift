//
//  EpisodeDetailViewViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 12.03.2025.

import Foundation
import UIKit

protocol EpisodeUIViewModelDelegate : AnyObject{
    func didSelectEpisode(_ episode : EpisodeModel)
    func didAddNewEpisodes(_ indexPaths : [IndexPath])
}

class EpisodeUIViewModel : NSObject {
    
    var isLoadingMoreEpisode = false
    
    weak var delegate : EpisodeUIViewModelDelegate?
    
    private let borderColors : [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]

    var episodes : [EpisodeModel] = []{
        didSet{
            for episode in episodes {
                let episodeCollection  = EpisodeCellViewModel(
                    episodeUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement()
                    ?? .systemBlue
                )
                if !collectionEpisodes.contains(episodeCollection) {
                    collectionEpisodes.append(episodeCollection)
                    }
         } }
    }
    
    var episodeInfoModel : GetAllEpisodesResponse.Info? = nil
    
    var collectionEpisodes : [EpisodeCellViewModel] = []
    
    public var shouldShowLoadMoreIndicator : Bool {
            return episodeInfoModel?.next != nil
    }
    
    func getEpisodes(){
        ServiceManager.shared.execute(RequestManager.listEpisodeRequest, expecting: GetAllEpisodesResponse.self){
            [weak self] result in
            switch result{
            case .success(let responseModel):
                self?.episodes = responseModel.results
                self?.episodeInfoModel = responseModel.info
            case .failure(let error):
                print(error)
            
            }
        }
    }
    
    func fetchMoreEpisodes(url:URL){
        guard !isLoadingMoreEpisode   else {  return }
        self.isLoadingMoreEpisode = true
        guard let request = RequestManager(url: url) else {
            isLoadingMoreEpisode = false
                    return
       }
        ServiceManager.shared.execute(request, expecting: GetAllEpisodesResponse.self){
           [weak self] result in
           guard let strongSelf = self else{return}
            switch result{
            case .success(let responseModel):
                let moreResults = responseModel.results
                                let info = responseModel.info
                                strongSelf.episodeInfoModel = info

                let originalCount = strongSelf.episodes.count
                                let newCount = moreResults.count
                                let total = originalCount+newCount
                                let startingIndex = total - newCount
                                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                                    return IndexPath(row: $0, section: 0)
                                })
                strongSelf.episodes.append(contentsOf: moreResults)

                                DispatchQueue.main.async {
                                    strongSelf.delegate?.didAddNewEpisodes(
                                         indexPathsToAdd
                                    )

                                    strongSelf.isLoadingMoreEpisode = false
                                }
            case .failure(_):
                  ("Error")
            }
        }
    }
}

extension EpisodeUIViewModel : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionEpisodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCollectionViewCell.identifider, for: indexPath) as? EpisodeCollectionViewCell
        else  {return UICollectionViewCell()}
        cell.configure(collectionEpisodes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let padding : CGFloat = 30
        let cellWidth = (screenWidth - padding)
        return CGSize(width: cellWidth, height:  100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("error")
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CharacterCollectionReusableView.reusableIdentifier, for: indexPath) as! CharacterCollectionReusableView
        footer.startAnimation()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (!shouldShowLoadMoreIndicator){
            return .zero
        } else{
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = episodes[indexPath.row]
        delegate?.didSelectEpisode(selectedCharacter)
    }
}

extension EpisodeUIViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingMoreEpisode,
              !collectionEpisodes.isEmpty,
              shouldShowLoadMoreIndicator,
              let nextUrlString = episodeInfoModel?.next,
              let url = URL(string: nextUrlString)
        else {return}
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){
           [weak self] t in
            let offset = scrollView.contentOffset.y
            let fixedHeight = scrollView.frame.size.height
            let totalContentSize = scrollView.contentSize.height
            if(offset >= (totalContentSize - fixedHeight) - 120){
                self?.fetchMoreEpisodes(url:url)
            }
            t.invalidate()
        }
       
    }
}
