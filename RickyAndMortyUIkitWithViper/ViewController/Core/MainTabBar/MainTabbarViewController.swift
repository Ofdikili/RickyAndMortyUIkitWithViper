//
//  MainTabbarViewController.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabbarApparance()
        configureTabs()
     }
    
    func configureTabbarApparance(){
        let apparance = UITabBarAppearance()
        apparance.configureWithOpaqueBackground()
        apparance.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        tabBar.standardAppearance = apparance
        tabBar.scrollEdgeAppearance = apparance
    }
    
    func configureTabs(){
        let charactersVC = createViewController(
            viewController: CharactersViewController(), name: "Characters", image: "person"
        )
        let locationVC = createViewController(
            viewController: LocationViewController(), name: "Location", image: "globe"
        )
        let episodeVC = createViewController(
            viewController: EpisodeViewController(), name: "Episode", image: "tv"
        )
        let settingsVC = createViewController(
            viewController: SettingsViewController(), name: "Settings", image: "gear"
        )
         setViewControllers([charactersVC,locationVC,episodeVC,settingsVC], animated: true)
    }
    
    func createViewController(viewController:UIViewController,name:String,image:String)->UIViewController{
        let viewController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = createTabBarItem(name: name, image: image)
        return viewController
    }
    
    func createTabBarItem(name:String,image:String)->UITabBarItem{
        return UITabBarItem(
            title: name, image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: "\(image).fill")
        )
    }
    

}
