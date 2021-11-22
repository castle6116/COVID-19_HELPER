//
//  Notice.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/11.
//

import Foundation

struct Notice : Codable{
    var code : Int
    var result_data : NoticeData
    var message : String
    
}

struct NoticeData : Codable{
    var list : [NoticeList]
}

struct NoticeList : Codable{
    /// 조회 횟수 ex ) 17
    var hit : Int
    /// 공지사항 입력 날짜  ex ) "2021/10/29 16:05:05",
    var createdDate : String
    /// 공지사항 수정 날짜  ex ) "2021/10/29 17:28:59",
    var modifiedDate : String
    /// 게시글 고유 번호 ex) 7
    var id : Int
    /// 게시글 제목 ex ) 안녕하세요
    var title : String
    /// 게시글 내용 ex ) 반갑습니다
    var content : String
    /// 열었는지 닫았는지 확인하는 변수
    var open : Bool? = false
}
