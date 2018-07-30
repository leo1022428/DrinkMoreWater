//
//  DrinkWaterTableViewCell.swift
//  DrinkMoreWater
//
//  Created by Che-wei LIU on 2018/7/20.
//  Copyright © 2018 Che-wei LIU. All rights reserved.
//

import UIKit

class DrinkWaterTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
