//
//  EpisodeListView.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 13.03.2025.
//

import UIKit

class EpisodeListView: UIView {
    let viewModel = EpisodeUIViewModel()
    let episodeUICollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifider)
        collection.register(CharacterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CharacterCollectionReusableView.reusableIdentifier)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(episodeUICollectionView)
        episodeUICollectionView.delegate = viewModel
        episodeUICollectionView.dataSource = viewModel
        configureConstraint()
        viewModel.getEpisodes()
    }
    
    func configureConstraint(){
        NSLayoutConstraint.activate(
            [
                episodeUICollectionView.leftAnchor.constraint(equalTo:self.leftAnchor),
                episodeUICollectionView.rightAnchor.constraint(equalTo:self.rightAnchor),
                episodeUICollectionView.bottomAnchor.constraint(equalTo:self.bottomAnchor),
                episodeUICollectionView.topAnchor.constraint(equalTo:self.topAnchor),
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


