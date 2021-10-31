//
//  News.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/18.
//

import Foundation

struct News : Codable{
    var lastBuildDate : String
    var total : Int
    var start : Int
    var display : Int
    var items : [Items]
}

struct Items : Codable{
    var title : String
    var originallink : String
    var link : String
    var description : String
    var pubDate : String
}
