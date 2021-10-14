//
//  SideMenuTableViewCell.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/11.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
