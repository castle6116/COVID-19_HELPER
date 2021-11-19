//
//  CommentList.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/18.
//

import Foundation

struct Comment_List : Codable{
    var code : Int
    var result_data : result_data
    var message : String
}

struct result_data : Codable{
    var data : [Comment_data]
}

struct Comment_data : Codable{
    /// 작성일
    var createdDate : String?
    /// 수정일
    var modifiedDate : String?
    /// 댓글 번호 (기본키)
    var id : Int?
    /// 게시글 번호
    var board_id : Int?
    /// 작성자
    var nickname : String?
    /// 글 내용
    var content : String?
    /// 추천
    var recommend : Int?
    /// 비 추천
    var deprecate : Int?
    /// 신고 (5회 초과시 자동삭제)
    var declaration : Int?
}
