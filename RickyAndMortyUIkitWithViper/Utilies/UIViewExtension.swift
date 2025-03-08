//
//  UIViewExtension.swift
//  RickyAndMortyUIkitWithViper
//
//  Created by Ömer Faruk Dikili on 8.03.2025.
//

import Foundation
import UIKit

extension UIView{
    func  addSubViews(_ subviews : UIView...){
        subviews.forEach{
            addSubview($0)
        }
    }
}
