//
//  CustomCell1.swift
//  CongressUSA
//
//  Created by Mukai Nong on 11/20/16.
//  Copyright © 2016 Mukai Nong. All rights reserved.
//

import UIKit

class CustomCell1: UITableViewCell {
    
    @IBOutlet weak var legimage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
