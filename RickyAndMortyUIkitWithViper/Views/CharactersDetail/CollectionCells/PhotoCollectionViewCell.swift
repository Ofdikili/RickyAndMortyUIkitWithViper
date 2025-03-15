//
//  PhotoCollectionViewCell.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static var identifider = "PhotoCollectionViewCell"
    
    var characterImage : UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(characterImage)
        addConstraint()
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate(
            [
                characterImage.topAnchor.constraint(equalTo:
                                                topAnchor),
                characterImage.bottomAnchor.constraint(equalTo:
                                                bottomAnchor),
                characterImage.leadingAnchor.constraint(equalTo:
                                                leadingAnchor),
                characterImage.trailingAnchor.constraint(equalTo:
                                                trailingAnchor)
            ]
        )
    }
    
    public func configure(_ viewModel : PhotoCellViewModels){
        viewModel.fetchImage{ [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.characterImage.image = UIImage(data: image)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.characterImage.image = UIImage(systemName: "photo.on.rectangle.angled.fill")
                }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
