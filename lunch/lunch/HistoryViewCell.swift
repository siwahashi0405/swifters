//
//  HistoryViewCell.swift
//  lunch
//
//  Created by 菅原 佑太 on 2017/06/25.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
