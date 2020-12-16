//
//  CustomTableViewCell.swift
//  CW2
//
//  Created by amier ali on 28/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    //the outlet for the view on the storyboard
    //it allows me to access it from the DetailViewController
    @IBOutlet weak var circularProgressBar: cuustomView!
    
    @IBOutlet weak var textName: UILabel!
    
    @IBOutlet weak var testing: UILabel!
    
    @IBOutlet weak var textStartDate: UILabel!
    
    @IBOutlet weak var textNotes: UILabel!
    
    @IBOutlet weak var textDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
