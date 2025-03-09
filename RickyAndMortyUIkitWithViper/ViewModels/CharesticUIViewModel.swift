//
//  CharesticUIViewModel.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import Foundation
import UIKit

class CharesticUIViewModel : NSObject{
    
    var characters : [CharacterModel] = []{
        didSet{
            collectionCharecters = characters.compactMap {
                CharacterCollectionViewModel(name: $0.name, status: $0.status, imageUrl: URL(string: $0.image))
                   }
        }
    }
    
    var collectionCharecters : [CharacterCollectionViewModel] = []
    
    func getCharacters(){
        ServiceManager.shared.execute(RequestManager.listCharactersRequest, expecting: GetAllCharactersResponse.self){
            [weak self] result in
            switch result{
            case .success(let responseModel):
                self?.characters = responseModel.results
            case .failure(let error):
                print(error)
            
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
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
