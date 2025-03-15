//
//  EpisodeDetailViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 12.03.2025.
//

import UIKit

final class EpisodeDetailViewController: UIViewController,
                                         EpisodeDetailViewViewModelDelegate ,
                                         EpisodeDetailViewDelegate


{
    func rmEpisodeDetailView(_ detailView: EpisodeDetailView, didSelect character: CharacterModel) {
        let vc = CharacterDetailViewController(detailVm: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

    private let viewModel : EpisodeDetailViewViewModel
    
    private let detailView = EpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewViewModel(endPointUrl: url)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func didTapShare(){
        
    }
    
    func didFetchedEpisodeDetails() {
        detailView.configure(with:viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.addSubview(detailView)
        addConstraint()
        detailView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(didTapShare)
        )
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraint(){
        NSLayoutConstraint.activate(
            [
                detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ]
        )
    }

}
