//
//  Styles.swift
//  CarbonFootprintTracking
//
//  Created by Teemu Rekola on 6.5.2021.
//

import Foundation
import UIKit

// Style collection

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

class customLabel: UILabel {
    override func didMoveToWindow() {
        self.textColor = UIColor.gray
        
    }
}

class customProgressView: UIProgressView {
    override func didMoveToWindow() {
        // Style
        self.progressTintColor = UIColor.green
        //progressView.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.sublayers![1].cornerRadius = 5
        self.subviews[1].clipsToBounds = true
        self.transform = self.transform.scaledBy(x: 1, y: 8)
    }
}
// to change backroundcolor: in viewDidLoad()
//  self.view.backgroundColor = UIColor.orange
