//
//  NoticeTableContentCell.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/11.
//

import UIKit

class NoticeTableContentCell: UITableViewCell {
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Content: UILabel!
    
    var open = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
