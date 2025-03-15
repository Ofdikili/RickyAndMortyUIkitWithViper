//
//  EpisodeCollectionViewCell.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    static var identifider = "EpisodeCollectionViewCell"
    
    var seasonLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    var nameLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var airDateLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        setUpLayer()
        contentView.addSubview(nameLabel)
        contentView.addSubview(seasonLabel)
        contentView.addSubview(airDateLabel)
    
        setUpConstraint()
    }
    
    func setUpLayer(){
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func setUpConstraint(){
        NSLayoutConstraint.activate(
            [
                seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
                seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
                seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor , multiplier: 0.3),
                
                nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
                nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
                nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
                nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor , multiplier: 0.3),
                
                airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
                airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
                airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor , multiplier: 0.3),
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(_ viewModel: EpisodeCellViewModel){
        viewModel.registerforData{
            [weak self]  data in
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode " + data.episode
            self?.airDateLabel.text = "Aired on" + data.air_date
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
    
}
