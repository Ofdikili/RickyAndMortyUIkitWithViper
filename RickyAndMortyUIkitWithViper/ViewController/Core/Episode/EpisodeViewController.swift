//
//  EpisodeViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    let episodeUI = EpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodeUI.viewModel.delegate = self
        navigationItem.title = "Episodes"
        view.addSubview(episodeUI)
        addSearchButton()
        configureConstraint()
        
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        
    }
    
    @objc private func didTapSearch(){
        let vc = SearchViewController(config: SearchViewController.Config(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureConstraint(){
        NSLayoutConstraint.activate([
            episodeUI.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeUI.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeUI.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeUI.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension EpisodeViewController : EpisodeUIViewModelDelegate {
    func didSelectEpisode(_ episode: EpisodeModel) {
        let detailVm = EpisodeDetailViewViewModel()
        let detailVc = EpisodeDetailViewController(url: URL(string: episode.url))
                navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func didAddNewEpisodes(_ indexPaths : [IndexPath]) {
        episodeUI.episodeUICollectionView.performBatchUpdates{
            episodeUI.episodeUICollectionView.insertItems(at: indexPaths)
        }
    }
  
    
    
}
