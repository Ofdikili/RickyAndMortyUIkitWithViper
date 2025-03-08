//
//  CharacterUIView.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import UIKit

class CharacterUIView: UIView {
    let viewModel = CharesticUIViewModel()
    let characterUICollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(characterUICollectionView)
        characterUICollectionView.delegate = viewModel
        characterUICollectionView.dataSource = viewModel
        configureConstraint()
        viewModel.getCharacters()
    }
    
    func configureConstraint(){
        NSLayoutConstraint.activate(
            [
                characterUICollectionView.leftAnchor.constraint(equalTo:self.leftAnchor),
                characterUICollectionView.rightAnchor.constraint(equalTo:self.rightAnchor),
                characterUICollectionView.bottomAnchor.constraint(equalTo:self.bottomAnchor),
                characterUICollectionView.topAnchor.constraint(equalTo:self.topAnchor),
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


