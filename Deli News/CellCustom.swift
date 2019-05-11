//
//  CellCustom.swift
//  Deli News
//
//  Created by Mohammad Yunus on 10/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit

class CellCustom: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
}
