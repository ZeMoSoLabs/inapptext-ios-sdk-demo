//
//  OutgoingTableViewCell.swift
//  InAppText SDK Demo
//
//  Created by Raja Vikram on 13/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit

class OutgoingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outgoingCellView: UIView!
    
    @IBOutlet weak var outgoingMessage: UILabel!
    
    @IBOutlet weak var deliveryStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outgoingCellView.layer.cornerRadius = 10
//        outgoingCellView.layer.masksToBounds = true
        outgoingCellView.layer.shadowOpacity = 0.2
        outgoingCellView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
