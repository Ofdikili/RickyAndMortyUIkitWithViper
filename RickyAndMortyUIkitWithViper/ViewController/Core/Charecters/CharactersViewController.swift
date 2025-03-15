//
//  CharactersViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import UIKit

class CharactersViewController: UIViewController {
    
    let charecterUI = CharacterUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charecterUI.viewModel.delegate = self
        navigationItem.title = "Characters"
        view.addSubview(charecterUI) 
        configureConstraint()
        addSearchButton()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        
    }
    
    @objc private func didTapSearch(){
        let vc = SearchViewController(config: SearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureConstraint(){
        NSLayoutConstraint.activate([
            charecterUI.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charecterUI.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            charecterUI.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charecterUI.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CharactersViewController : CharesticUIViewModelDelegate {
    func didAddNewCharacters(_ indexPaths : [IndexPath]) {
        charecterUI.characterUICollectionView.performBatchUpdates{
            charecterUI.characterUICollectionView.insertItems(at: indexPaths)
        }
    }
    
    func didSelectCharacter(_ character: CharacterModel) {
        let detailVm = CharacterDetailUIViewModel(character: character)
        let detailVc = CharacterDetailViewController(detailVm: detailVm)

        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
}




