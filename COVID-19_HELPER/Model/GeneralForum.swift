//
//  GeneralForum.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import Foundation

struct GeneralForum : Codable{
    var code : Int
    var result_data : Forum_data
    var message : String
}

struct Forum_data : Codable{
    var data : [Forum_list]
    /// 총 게시글 수
    var totalCount :Int
    /// 요청한 페이지
    var requestPage : Int
    /// 총 페이지 수 ( TotalCount / size )
    var totalPage : Int
}

struct Forum_list : Codable{
    /// 작성일
    var createdDate : String
    /// 수정일
    var modifiedDate : String
    /// 게시글 번호 (기본키)
    var id : Int
    /// 제목
    var title : String
    /// 작성자
    var nickname : String
    /// 글 내용
    var content : String
    /// 해당 게시판 댓글갯수
    var review_count : Int
    /// 조회수
    var hit : Int
    /// 추천
    var recommend : Int
    /// 비 추천
    var deprecate : Int
    /// 신고 (5회 초과시 자동삭제)
    var declaration : Int
}
