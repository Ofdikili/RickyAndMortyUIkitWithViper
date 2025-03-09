//
//  CharacterCollectionReusableView.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 9.03.2025.
//

import UIKit

class CharacterCollectionReusableView: UICollectionReusableView {
    static let reusableIdentifier = "CharacterCollectionReusableView"
    
    private let spinnerView : UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style : .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinnerView)
        setUpConstraints()
    }
    func setUpConstraints(){
        NSLayoutConstraint.activate(
            [
                spinnerView.centerXAnchor.constraint(equalTo:
                                                        centerXAnchor),
                spinnerView.centerYAnchor.constraint(equalTo:
                                                        centerYAnchor),
                spinnerView.heightAnchor.constraint(equalToConstant: 100),
                spinnerView.widthAnchor.constraint(equalToConstant: 100)
            ]
        )
    }
    
    func startAnimation(){
        spinnerView.startAnimating()
    }
    func stopAnimation(){
        spinnerView.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
