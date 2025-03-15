//
//  EpisodeDetailViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 12.03.2025.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {
    
    private let viewModel : EpisodeDetailViewViewModel
    
    private let detailView = EpisodeDetailView()
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewViewModel(endPointUrl: url)
       
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func didTapShare(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self, action: #selector(didTapShare)
        )
        addConstraint()
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
