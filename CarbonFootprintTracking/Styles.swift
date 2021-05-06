//
//  Styles.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 6.5.2021.
//

import Foundation
import UIKit

extension UIButton {
    func applyDesing() {
        // button style
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 7
        self.setTitleColor(UIColor.white, for: .normal)
        
        /*
        //shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        */
    }
}

class roundButton: UIButton {
    override func didMoveToWindow() {
        // button style
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 7
        self.setTitleColor(UIColor.white, for: .normal)
        
        /*
        //shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        */
    }
}
