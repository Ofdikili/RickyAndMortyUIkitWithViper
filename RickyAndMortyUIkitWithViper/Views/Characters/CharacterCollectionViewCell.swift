//
//  CharacterCollectionViewCell.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    public static var identifier =  "CharacterCollectionViewCell"
    var nameLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var statusLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var characterImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubViews(characterImage, nameLabel,statusLabel)
        addConstraints()
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
        characterImage.image = UIImage(systemName: "person.fill")
        
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            characterImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            characterImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor,constant: -3),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: CharacterCollectionViewModel) {
        statusLabel.text = viewModel.statusText
        nameLabel.text = viewModel.name
        viewModel.fetchImage(){
            [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.characterImage.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
