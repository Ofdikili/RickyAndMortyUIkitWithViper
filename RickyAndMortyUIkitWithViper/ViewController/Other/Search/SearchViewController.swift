//
//  SearchViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 13.03.2025.
//

import UIKit

class SearchViewController: UIViewController {
    
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location // name | type

            var endpoint: EndPoints {
                switch self {
                case .character: return .character
                case .episode: return .episode
                case .location: return .location
                }
            }


            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }

        let type: `Type`
    }
    
    private let config : Config
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
    }
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   


}
