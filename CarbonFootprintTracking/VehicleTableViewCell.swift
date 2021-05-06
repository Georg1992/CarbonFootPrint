//
//  VehicleTableViewCell.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 5.5.2021.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {
    
    static let identifier = "VehicleTableViewCell"
    
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var carbonLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
