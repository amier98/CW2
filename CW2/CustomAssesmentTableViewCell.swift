//
//  CustomAssesmentTableViewCell.swift
//  CW2
//
//  Created by amier ali on 30/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
//new UITableView cell created in order to access the labels
class CustomAssesmentTableViewCell: UITableViewCell {
    //outlets create for the custom table view cell
    @IBOutlet weak var assesmentName: UILabel!
    
    @IBOutlet weak var moduleName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
