//
//  DetailNotice.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import Foundation

struct boardList : Codable{
    var code : Int
    var result_data : account
    var message : String
}

struct account : Codable{
    var account : board
}

struct board : Codable{
    /// 작성일
    var createdDate : String?
    /// 수정일
    var modifiedDate : String?
    /// 게시글 번호 (기본키)
    var id : Int?
    /// 제목
    var title : String?
    /// 비밀번호 (글 삭제시 필요)
    var password : String?
    /// 작성자
    var nickname : String?
    /// 글 내용
    var content : String?
    /// 조회수
    var hit : Int?
    /// 추천
    var recommend : Int?
    /// 비 추천
    var deprecate : Int?
    /// 신고 (5회 초과시 자동삭제)
    var declaration : Int?
    /// 게시판 삭제 판별
    var view : Int?






}
