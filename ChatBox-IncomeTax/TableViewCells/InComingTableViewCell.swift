//
//  InComingTableViewCell.swift
//  InAppText SDK Demo
//
//  Created by Raja Vikram on 13/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit

class InComingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var incomingCellView: UIView!
    
    @IBOutlet weak var incomingMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        incomingCellView.layer.cornerRadius = 10
//                incomingCellView.layer.masksToBounds = true
        incomingCellView.layer.shadowOpacity = 0.2
        incomingCellView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
