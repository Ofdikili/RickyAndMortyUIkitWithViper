//
//  EpisodeDetail.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 13.03.2025.
//

import UIKit

protocol EpisodeDetailViewDelegate : AnyObject {
    func rmEpisodeDetailView(
        _ detailView : EpisodeDetailView,
        didSelect character : CharacterModel
    )
}

class EpisodeDetailView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var viewModel : EpisodeDetailViewViewModel?{
        didSet{
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3){
                self.collectionView?.alpha = 1
            }
        }
    }
    
    public weak var delegate : EpisodeDetailViewDelegate?
    
    private var collectionView : UICollectionView?
    
    private let spinner : UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubViews(collectionView,spinner)
        self.collectionView = collectionView
        addConstraints()
        spinner.startAnimating()
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout{
            section , _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: EpisodeInfoCollectionViewCell.identifier)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        return collectionView
    }
    
    
    public func addConstraints(){
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with viewModel : EpisodeDetailViewViewModel){
        self.viewModel = viewModel
    }
    
}

extension EpisodeDetailView : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else
        {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType{
        case .characters(let viewModels):
            return viewModels.count
        case .information(let viewModels): return viewModels.count
       
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else
        {
            fatalError()
        }
        let sectionType = sections[indexPath.section]
        switch sectionType{
        case .characters(let viewModels):
            let vm = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                    CharacterCollectionViewCell.identifier  , for: indexPath) as? CharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(viewModel: vm)
            return cell
            
        case .information(let viewModels):
            let vm = viewModels[indexPath.row]
         guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                EpisodeInfoCollectionViewCell.identifier , for: indexPath) as? EpisodeInfoCollectionViewCell else{
             fatalError()
         }
            cell.configure(with: vm)
            return cell
       
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else{
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        switch sectionType{
        case .information:
            break
        case .characters:
          guard  let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self,didSelect: character)
        }
    }
    
}

extension EpisodeDetailView{
    func layout(for section : Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        switch sections[section]{
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    func createInfoLayout()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)),subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func createCharacterLayout()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240)),subitems: [item,item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
