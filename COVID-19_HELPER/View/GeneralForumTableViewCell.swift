//
//  GeneralForumTableViewCell.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import UIKit

class GeneralForumTableViewCell: UITableViewCell {
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var ViewCount: UILabel!
    @IBOutlet weak var GoodCount: UILabel!
    @IBOutlet weak var Reword: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var ControlView: UIView!
    @IBOutlet weak var reviewCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected{
            ControlView.layer.borderColor = UIColor.blue.cgColor
        }else{
            ControlView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

}
