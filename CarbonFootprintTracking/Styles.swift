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
        
    }
}

class roundButtonBlue: UIButton {
    override func didMoveToWindow() {
        // button style
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 7
        self.setTitleColor(UIColor.white, for: .normal)

    }
}

class customLabel: UILabel {
    override func didMoveToWindow() {
        self.textColor = UIColor.gray
        
    }
}

class customTextField: UITextField {
    override func didMoveToWindow() {
        self.textColor = UIColor.gray
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 7
        self.layer.borderColor = UIColor.orange.cgColor
    }
}
