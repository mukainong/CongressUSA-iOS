//
//  CustomCell2.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/20/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit

class CustomCell3: UITableViewCell {
    
    @IBOutlet weak var leftCell: UILabel!
    @IBOutlet weak var rightCell: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
