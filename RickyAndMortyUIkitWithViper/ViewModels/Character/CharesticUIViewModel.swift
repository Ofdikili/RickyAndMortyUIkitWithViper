//
//  CharesticUIViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import Foundation
import UIKit

protocol CharesticUIViewModelDelegate : AnyObject{
    func didSelectCharacter(_ character : CharacterModel)
    func didAddNewCharacters(_ indexPaths : [IndexPath])
}

class CharesticUIViewModel : NSObject {
    
    var isLoadingMoreCharacter = false
    
    weak var delegate : CharesticUIViewModelDelegate?

    var characters : [CharacterModel] = []{
        didSet{
            for character in characters {
                let characterCollection  = CharacterCollectionViewModel(name: character.name, status: character.status, imageUrl: URL(string: character.image))
                if !collectionCharecters.contains(characterCollection) {
                    collectionCharecters.append(characterCollection)
                    }
         } }
    }
    
    var characterInfoModel : GetAllCharactersResponse.Info? = nil
    
    var collectionCharecters : [CharacterCollectionViewModel] = []
    
    public var shouldShowLoadMoreIndicator : Bool {
            return characterInfoModel?.next != nil
    }
    
    func getCharacters(){
        ServiceManager.shared.execute(RequestManager.listCharactersRequest, expecting: GetAllCharactersResponse.self){
            [weak self] result in
            switch result{
            case .success(let responseModel):
                self?.characters = responseModel.results
                self?.characterInfoModel = responseModel.info
            case .failure(let error):
                print(error)
            
            }
        }
    }
    
    func fetchMoreCharacter(url:URL){
        guard !isLoadingMoreCharacter   else {  return }
        self.isLoadingMoreCharacter = true
        guard let request = RequestManager(url: url) else {
                    isLoadingMoreCharacter = false
                    return
       }
       ServiceManager.shared.execute(request, expecting: GetAllCharactersResponse.self){
           [weak self] result in
           guard let strongSelf = self else{return}
            switch result{
            case .success(let responseModel):
                let moreResults = responseModel.results
                                let info = responseModel.info
                                strongSelf.characterInfoModel = info

                                let originalCount = strongSelf.characters.count
                                let newCount = moreResults.count
                                let total = originalCount+newCount
                                let startingIndex = total - newCount
                                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                                    return IndexPath(row: $0, section: 0)
                                })
                                strongSelf.characters.append(contentsOf: moreResults)

                                DispatchQueue.main.async {
                                    strongSelf.delegate?.didAddNewCharacters(
                                         indexPathsToAdd
                                    )

                                    strongSelf.isLoadingMoreCharacter = false
                                }
            case .failure(_):
                  ("Error")
            }
        }
    }
}

extension CharesticUIViewModel : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCharecters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell
        else  {return UICollectionViewCell()}
        cell.configure(viewModel: collectionCharecters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let padding : CGFloat = 30
        let cellWidth = (screenWidth - padding) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.5 )
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
        let selectedCharacter = characters[indexPath.row]
        delegate?.didSelectCharacter(selectedCharacter)
    }
}

extension CharesticUIViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingMoreCharacter,
              !collectionCharecters.isEmpty,
              shouldShowLoadMoreIndicator,
              let nextUrlString = characterInfoModel?.next,
              let url = URL(string: nextUrlString)
        else {return}
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){
           [weak self] t in
            let offset = scrollView.contentOffset.y
            let fixedHeight = scrollView.frame.size.height
            let totalContentSize = scrollView.contentSize.height
            if(offset >= (totalContentSize - fixedHeight) - 120){
                self?.fetchMoreCharacter(url:url)
            }
            t.invalidate()
        }
       
    }
}
