//
//  EpisodeInfoCollectionViewCell.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 15.03.2025.identifier
//

import UIKit

class EpisodeInfoCollectionViewCell: UICollectionViewCell {
    public static let identifier = "EpisodeInfoCollectionViewCell"
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubViews(titleLabel,valueLabel)
        addConstraint()
        setUpLayer()
        
    }
    
    private func addConstraint(){
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
                titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -4),
                
                valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
                valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
                valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -4),
                
                titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
                valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayer(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with viewModel:EpisodeInfoCollectionViewCellViewModel){
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}
