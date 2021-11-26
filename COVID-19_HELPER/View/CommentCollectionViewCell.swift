//
//  CommentCollectionViewCell.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/18.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var NickName: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var GoodButton: UIButton!
    @IBOutlet weak var NotGoodButton: UIButton!
    @IBOutlet weak var buttonView: ButtonPanelView!
    
    @IBAction func GoodButtonClick(_ sender: Any){
        Good()
    }
    @IBAction func NotGoodButton(_ sender: Any) {
        Bad()
    }
    
    var Good : (() -> ()) = {}
    var Bad : (() -> ()) = {}
    
}
