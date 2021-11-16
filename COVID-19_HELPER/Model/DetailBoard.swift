//
//  DetailNotice.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import Foundation

struct boardList : Codable{
    var code : Int
    var result_data : board
    var message : String
}

struct board : Codable{
    var password : String
    var hit : Int
    var deprecate : Int
    var nickname : String
    var view : Int
    var modifiedDate : String
    var recommend : Int
    var id : Int
    var title : String
    var declaration : Int
    var content : String
    var createDate : String
}
