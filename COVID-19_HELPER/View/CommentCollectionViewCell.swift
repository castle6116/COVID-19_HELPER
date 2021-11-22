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
    @IBOutlet weak var Declaration: UIButton!
    @IBOutlet weak var GoodButton: UIButton!
    @IBOutlet weak var NotGoodButton: UIButton!
    @IBOutlet weak var DeclarationButton: UIButton!
    
    @IBAction func GoodButtonClick(_ sender: Any){
        Good()
    }
    @IBAction func NotGoodButton(_ sender: Any) {
        Bad()
    }
    @IBAction func DeclarationButtonClick(_ sender: Any) {
        Declara()
    }
    
    func addOne(left a: Int, right b: Int) -> Int {
         return a + b
    }

    func addTwo(a: Int = 0, b: Int = 0) -> Int {
         return a + b
    }
    
    var Good : (() -> ()) = {}
    var Bad : (() -> ()) = {}
    var Declara : (() -> ()) = {}
    
}
