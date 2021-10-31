//
//  NewsTableViewCell.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/18.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var Title: UILabel!
    @IBOutlet var Content: UILabel!
    @IBOutlet var Day: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
