//
//  Center.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/28.
//

import Foundation

struct Center : Codable{
    var currentCount : Int      // 284
    var data : [Address]
    var matchCount : Int        // 284,
    var page : Int              // 1,
    var perPage : Int           // 284,
    var totalCount : Int        // 284
}

struct Address : Codable{
    var address : String        //"서울특별시 중구 을지로 39길 29",
    var centerName : String     //"코로나19 중앙 예방접종센터",
    var centerType : String     //"중앙/권역",
    var createdAt : String      //"2021-03-03 07:00:52",
    var facilityName : String   //"국립중앙의료원 D동",
    var id : Int                //1,
    var lat : String            // "37.567817",
    var lng : String            // "127.004501",
    var org : String            //"국립중앙의료원",
    var phoneNumber : String    //"02-2260-7114",
    var sido : String           // "서울특별시",
    var sigungu : String        //"중구",
    var updatedAt : String      //"2021-07-16 04:55:08",
    var zipCode : String        //"04562"
}
            
            
