//
//  ChecklistTableViewCell.swift
//  RWTableView
//
//  Created by Jaspal on 2/14/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    @IBOutlet weak var todoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
