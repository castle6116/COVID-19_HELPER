//
//  Vaccine.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/27.
//

import Foundation

struct Vaccine : Codable{
    var currentCount : Int
    var data : [data_nomal]
    var matchCount : Int
    var page : Int
    var perPage : Int
    var totalCount : Int
}

struct data_nomal : Codable{
    var accumulatedFirstCnt : Int
    var accumulatedSecondCnt : Int
    var accumulatedThirdCnt : Int
    var baseDate : String
    var firstCnt : Int
    var id : Int
    var secondCnt : Int
    var sido : String
    var thirdCnt : Int
    var totalFirstCnt : Int
    var totalSecondCnt : Int
    var totalThirdCnt : Int
}

