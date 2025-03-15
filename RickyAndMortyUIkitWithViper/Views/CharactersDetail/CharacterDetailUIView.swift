//
//  CharacterDetailUIView.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import UIKit

class CharacterDetailUIView: UIView {
    
    var detailUIViewModel : CharacterDetailUIViewModel
    
    var collectionView : UICollectionView?
    
    init(frame: CGRect,viewModel : CharacterDetailUIViewModel) {
        self.detailUIViewModel = viewModel
        super.init(frame: frame)
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        addConstraint()
    }
    
    func addConstraint() {
        guard let collectionView  = collectionView else { return }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func createCollectionView()-> UICollectionView{
        let layout = UICollectionViewCompositionalLayout{
            sectionIndex , _ in
            return self.detailUIViewModel.createSection(sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifider)
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifider)
        collectionView.register(InformationCollectionViewCell.self, forCellWithReuseIdentifier: InformationCollectionViewCell.identifider)
        return collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


