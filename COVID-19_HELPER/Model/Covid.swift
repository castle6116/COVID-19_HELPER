//
//  Covid.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/11.
//

import Foundation

class Covid {
    var stateDt : String!       // 기준일
    var stateTime : String!     // 기준 시간
    var decideCnt : String!     // 확진자 수
    var clearCnt : String!      // 격리 해제 수
    var examCnt : String!       // 치료중 환자 수
    var deathCnt : String!      // 사망자 수
    var careCnt : String!       // 치료중 환자 수
    var resutlNegCnt : String!  // 결과 음성 수
    var accExamCnt : String!    // 누적 검사 수
    var accExamCompCnt : String!//누적 검사 완료 수
    var accDefRate : String!    // 누적 확진률
    var createDt : String!      // 등록 일 시 분 초
}
