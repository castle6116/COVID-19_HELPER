# 코로나19 도우미 어플 (가칭)
이 어플의 목적은 코로나 19 에 대한 정보 (지역별 확진자 , 뉴스 기사 , 근처 진료소 , 접종 현황 ) 
사용자 간 소통이 가능한 게시판을 만들어 정보 공유를 목표로 만들었습니다.

## 제작된 플랫폼
> iOS : 김진우 / [iOS](https://github.com/castle6116/COVID-19_HELPER)

> Android : 구태호 / [Android](https://github.com/GuTaeHo/CovidSituation)

> Web : 권수형 /  [FrontEnd](https://github.com/Byeong-gook/cosiguk/tree/master)

> BackEnd : 기병국 / [BackEnd](https://github.com/Byeong-gook/cosiguk/tree/master)

- 목차
1. [어플 소개](#1-어플-소개)
2. [Controller 설명](#2-Controller-설명)
   1. [function 설명](#21-function-설명)
3. [기술 및 라이센스](#3-기술-및-라이센스)
   1. [iOS 기술 및 라이센스](#ios에서-사용된-기술-및-라이센스)
   2. [Android 기술 및 라이센스](#android에서-사용된-기술-및-라이센스)
   3. [Web  기술 및 라이센스](#front-end-web-에서-사용된-기술-및-라이센스)
   4. [BackEnd  기술 및 라이센스](#backend에서-사용된-기술-및-라이센스)

----

## 1. 어플 소개
> 어플의 기능은 크게 코로나19 상황판 , 뉴스 상황판 , 백신 현황 (지도), 이용자들의 게시판 , 공지사항 로 분류 되어 있습니다.    
> 어플 제작 목표는 코로나 19 그리고 다른 질병 등이 창궐 했을 때 사용자에게 정확하고 빠른 정보를 전달 하고자 제작 하게 되었습니다.    
> 코로나19 상황판은 현재 확진자의 현황 , 시/도별 감염 현황을 알려 주고 있습니다.    
> 뉴스 상황판은 현재 뜨거운 이슈인 코로나19 관련 뉴스만 출력되게 하여 사용자들이 빠르게 정보를 접할 수 있게 제작 하였습니다.    
> 백신 현황은 전 국민들의 예방 접종 현황을 표출 하고 뿐만 아니라 자기 중심으로 15km 안의 예방접종센터의 거리 , 전화번호 , 위치 등을 표출 하여 사용자가 접근성이 높아지도록 하였습니다.    
> 게시판은 이용자들이 코로나 나 혹은 다른 질병에 대해서 소통할 수 있는 장을 만들었습니다.    
> 공지사항은 어플의 공지 사항을 출력하며 탭 했을 때 밑으로 펴지는 형식으로 제작 하였습니다.    

<img width="20%" src="https://user-images.githubusercontent.com/46862400/143527515-b579004c-f7c0-434e-a9bb-527deac8c35e.PNG"/><img width="20%" src="https://user-images.githubusercontent.com/46862400/143527534-b31bcf82-cb53-4cd9-85d6-6f6fe21de7c3.PNG"/><img width="20%" src="https://user-images.githubusercontent.com/46862400/143527537-e9576438-a5a9-40bf-b1f3-b18316974387.PNG"/><img width="20%" src="https://user-images.githubusercontent.com/46862400/143527540-c986beef-fcc5-439b-8ab0-69241308775d.PNG"/><img width="20%" src="https://user-images.githubusercontent.com/46862400/143527543-6992eafd-2e7b-41b4-8b6d-d0b89e90fbca.PNG"/>

----

## 2. Controller 설명
- 메인화면(1번 페이지) / MainViewController 
    + 공공데이터 포털데이터를 받아와 사용자들에게 정보를 뿌려줌   
     코로나19 예방접종 통계 데이터 조회 API , 코로나19 시/도별 발생 현황을 받아옵니다.
     CollectionView를 사용하여 제작 하였으며 인원 수 1000명 단위로 , 를 찍어주는 기능,
     XML파싱 기능 , 위로 당겼을 때 새로고침 되는 기능 제작 하였음.
     CollectionView 안에 ScrollView를 넣어 드래그가 가능하게 만듦 
     (ScrollView를 굳이 안넣어도 되었지만 초반에 만들어서 후에 수정할 예정)
     시/도별 API에서 받아온 객체를 기준으로 지역 갯수를 체크 한 뒤 cell 갯수 반환 하여 각 지역별로 뿌려주게 제작함  
- SideMenuController
    + 어플의 왼쪽 상단에 메뉴바를 만들어 누르면 나오게 만든 사이드바 메뉴
    크게 사용방법 , 공지사항 , 라이센스 , 어플 버전을 표출 하게 하였음.
    사용방법을 누를 시 HowToUseViewController로 연결 됨.
    공지사항을 누를 시 NoticeViewController로 연결 됨.
    라인센스를 누를 시 LicenseViewController로 연결 됨.
    - HowToUseViewController
        + 이용자들이 간단하게 볼 수 있게 드래그 형식으로 옆으로 넘기면 이미지와 셀이 변경 되는 형식으로 제작
        CollectionView와 Pager를 사용 layout은 flowLayout으로 배치 하였음.  
        
    - NoticeViewController
        + 어플의 공지사항을 표출 하기 위해서 제작하였으며 TableView를 사용하여 클릭시 펴지는 형식으로 사용
        Alamofire 사용됨   API통신으로 팀원이 제작한 BackEnd에 통신 
        통신에 성공하면 tableView를 reload하여 이용자에게 표출 될 수 있도록 만듦
        API에서 받아온 객체 기준으로 count 하여 tableCell 갯수 지정
        
    - LicenseViewController
        + 어플에 사용된 오픈소스 라이브러리들을 표출 하기 위해서 제작할 예정 TableView로 제작하여
        클릭 시 화면이 넘어가는 형식으로 만들려고 예정 중
    
- NewsViewController
    + 네이버 검색 API를 사용하여 검색 없이 뉴스를 표출 하기 위해 제작
    간단하게 해당 뉴스 내용을 보여주고 클릭 시 사이트로 넘어가는 형식
    Alamofire 사용 하였음 (네이버 검색 api 시간 반환 형식을 잘 몰라서 엄청 헤맸던 기억이 남)
    API에서 받아온 객체 기준으로 count 하여 tableCell 갯수 지정 
    
- VaccineViewController
    + 공공데이터 API를 사용하여 예방접종 통계 데이터 조회 서비스 , 예방접종센터 조회서비스를 가져와
    API에서 받아온 객체 기준으로 자료 입력 예방접종센터 정보를받아와 X,Y 좌표를 기준으로 반경 15km 내의
    접종센터를 거리 계산 하여 출력, 지도로 보면 가독성이 떨어질 수 있음으로 tableView 형식으로
    리스트로 출력 하였습니다. 사용자가 정보를 새로고침 할 수 있도록 새로고침 버튼도 넣었습니다.

- GeneralForumViewController
    + TableView를 사용하여 제작 하였습니다. BackEnd에 API요청을 하여 값을 가져와 글이 만들어진 시간을
    토대로 정렬 하였습니다. 게시글의 제일 아래로 내리면 자동으로 10개의 게시글을 요청합니다.
    게시글을 누르면 DetailForumViewController로 이동하여 세부 페이지를 출력 합니다.
    
- DetailForumViewController
    + CollectionView를 사용하여 만들었고 글 내용 (Header) 댓글 (Content) 글쓰기 (View) 형식으로
    제작 하였습니다. Header은 글 내용에 따라 가변적으로 사이즈가 변하도록 만들었습니다. 추천 , 비추천 버튼을
    추가하여 사용자들이 한눈에 알아볼 수 있도록 제작 하였습니다. 게시글 그리고 댓글에 대해서 더보기 버튼을 누르면
    StackView를 사용 하여 펴지며 그 안에 신고, 수정 기능을 넣었습니다. 그리고 신고와 추천, 비추천은 IP당 한번만 
    가능하게 제작하였습니다. 하단에는 글쓰기가 있으며 텍스트 필드를 누르면 키보드가 같이 올라가 이용자가 사용할 때
    불편함이 없도록 제작 하였습니다.
    
### 2.1 function 설명
- MainViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
    
       + initRefresh ()   
        -   
        
       + updateUI (refresh: UIRefreshControl)   
        -   
        
       + DecimalWon (value:Int,cot:Int) , (value:String) , (value:String,cot:Int)   
        -   
        
       + textinput()    
        -   
        
       + COVID_CONNECT (day : Int)   
        -   
        
       + COVID_Desult_CONNECT (day : Int)   
        -   
        
       + parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])   
        -   
        
       + parser(_ parser: XMLParser, foundCharacters string: String)   
        -   
        
       + parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)   
        -   
        
       +    
       
    </details>
    
- SideMenuController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- NewsViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- VaccineViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- NoticeViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- HowToUseViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- LicenseViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- GeneralForumViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
- DetailForumViewController
    <details markdown="1">
    <summary>접기/펼치기</summary>
       
    <!--summary 아래 빈칸 공백 두고 내용을 적는공간-->
    
    </details>
    
----

## 3. 기술 및 라이센스

### iOS에서 사용된 기술 및 라이센스

- Alamofire (라이브러리 HTTP 통신 / JSON 파라미터 인코딩 / URL 인코딩)
- AutoLayout (뷰간 제약조건 설정)
- CoreLocation (GPS 모듈)
- CocoaPods (라이브러리 관리 매니저)
- Codable (프로토콜 변환 / JSON 파싱)
- CollectionView / FlowLayout / TableView / ScrollView (레이아웃 표출 객체)
- RefreshControl (드래그시 새로고침)
- Naver Search API (뉴스 검색 API)
- SideMenu (라이브러리 사이드 메뉴)
- XML Parser (XML 파싱)

### 라이센스
- MIT License (KeyChainSwift)
> Copyright (c) 2015 - 2019 Evgenii Neumerzhitckii

- MIT License (SideMenu)
> Copyright (c) 2015 Jonathan Kent  [contact@jonkent.me](mailto:contact@jonkent.me) 

- Alamofire
> Copyright (c) 2014-2021 Alamofire Software Foundation (http://alamofire.org/)

-----

### Android에서 사용된 기술 및 라이센스

- 위치정보 라이브러리
> gms:play-services-location 

- HTTP 통신 라이브러리
> okhttp3:okhttp
> okhttp3:logging-interceptor
> retrofit2:retrofit

- GSON 파서
> retrofit2:converter-gson

- XML 파서
> tikxml:annotation
> tikxml:core
> tikxml:retrofit-converter
> tikxml:processor

- 위험 권한
> ted:tedpermission

- 롬복
> projectlombok:lombok

- 인디케이터
> relex:circleindicator

- 위치 주소 변환
> Geocoder

- 뷰 페이저 (화면 전환)
> viewpager2:viewpager2

### 라이센스

- Copyright 2013 Square, Inc. (HTTP 통신)
- Copyright 2013 Square, Inc. (GSON 파서)
- Copyright 2015 Tickaroo (XML 파서)
- Copyright 2021 Ted Park (위험 권한)
- Copyright (C) 2009-2021 The Project Lombok Authors. (lombok)
- Copyright 2018 ongakuer (뷰 페이저 인디케이터)

---

### Front End (Web) 에서 사용된 기술 및 라이센스
- React (UI용 javascript 라이브러리)
- react-router-dom (react routing 라이브러리)
- axios (promise base의 브라우저 및 node.js용 http 클라이언트)
- material-ui (react용 UI 라이브러리)
- styled-components (react용 CSS in JS 라이브러리)

### 라이센스
- Copyright (c) Facebook, Inc. and its affiliates.(React)
- Copyright (c) 2021 Ernesto Garcia (react-router-dom)
- Copyright (c) 2014-present Matt Zabriskie (axios)
- Copyright (c) 2014 Call-Em-All (material-ui)
- Copyright (c) 2016-present Glen Maddern and Maximilian Stoiber (styled-components)

----

### BackEnd에서 사용된 기술 및 라이센스
- Thymeleaf (HTML 템플릿 엔진)
- SpringBoot (Spring 프레임워크 [ JPA(ORM 기술 표준)
- HTTPEntity (Http 프로토콜 활용한 기술) ]
- 서버 :  라즈베리파이 (WAS 스프링부트 내장톰캣) 
- DB: MariaDB

### 라이센스
Apache License Version 2.0 (TomCat)

Copyright (C) 2009-2021 The Project Lombok Authors. (Lombok)

----

### iOS License

#### Alamofire

```
Copyright (c) 2014-2021 Alamofire Software Foundation (http://alamofire.org/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


#### KeychainSwift

```
The MIT License

Copyright (c) 2015 - 2019 Evgenii Neumerzhitckii

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```


#### SideMenu

```
Copyright (c) 2015 Jonathan Kent contact@jonkent.me

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Generated by CocoaPods - https://cocoapods.org
```


----

### Android License

#### Retrofit2 

```
Copyright 2013 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

#### Converter-Gson

```
Copyright 2013 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

#### Tickaroo

```
Copyright 2015 Tickaroo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

#### TedPermission

```
Copyright 2021 Ted Park

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

#### Lombok

```
Copyright (C) 2009-2021 The Project Lombok Authors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

#### CircleIndicator

```
ongakuer/CircleIndicator is licensed under the

Apache License 2.0
A permissive license whose main conditions require preservation of copyright and license notices. Contributors provide an express grant of patent rights. Licensed works, modifications, and larger works may be distributed under different terms and without source code.

 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```

---

### Web License

---

#### React
````
MIT License 

Copyright (c) Facebook, Inc. and its affiliates.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````

#### react-router-dom

````
MIT License

Copyright (c) 2021 Ernesto Garcia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````

#### axios
````
Copyright (c) 2014-present Matt Zabriskie

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
````

#### material-UI
````
The MIT License (MIT)

Copyright (c) 2014 Call-Em-All

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````

#### styled-components
````
MIT License

Copyright (c) 2016-present Glen Maddern and Maximilian Stoiber

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
````


----

### BackEnd License

---

#### Lombok

````
    Copyright (C) 2009-2021 The Project Lombok Authors.
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
    
    
````


#### JSON

````
    Copyright (c) 2002 JSON.org
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including without limitation the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so, subject to the following conditions:
     The above copyright notice and this permission notice shall be included in all
     copies or substantial portions of the Software.
     The Software shall be used for Good, not Evil.
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.

````


#### JSON-SIMPLE



````
                                     Apache License
                               Version 2.0, January 2004
                            http://www.apache.org/licenses/
    
       TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
    
       1. Definitions.
    
          "License" shall mean the terms and conditions for use, reproduction,
          and distribution as defined by Sections 1 through 9 of this document.
    
          "Licensor" shall mean the copyright owner or entity authorized by
          the copyright owner that is granting the License.
    
          "Legal Entity" shall mean the union of the acting entity and all
          other entities that control, are controlled by, or are under common
          control with that entity. For the purposes of this definition,
          "control" means (i) the power, direct or indirect, to cause the
          direction or management of such entity, whether by contract or
          otherwise, or (ii) ownership of fifty percent (50%) or more of the
          outstanding shares, or (iii) beneficial ownership of such entity.
    
          "You" (or "Your") shall mean an individual or Legal Entity
          exercising permissions granted by this License.
    
          "Source" form shall mean the preferred form for making modifications,
          including but not limited to software source code, documentation
          source, and configuration files.
    
          "Object" form shall mean any form resulting from mechanical
          transformation or translation of a Source form, including but
          not limited to compiled object code, generated documentation,
          and conversions to other media types.
    
          "Work" shall mean the work of authorship, whether in Source or
          Object form, made available under the License, as indicated by a
          copyright notice that is included in or attached to the work
          (an example is provided in the Appendix below).
    
          "Derivative Works" shall mean any work, whether in Source or Object
          form, that is based on (or derived from) the Work and for which the
          editorial revisions, annotations, elaborations, or other modifications
          represent, as a whole, an original work of authorship. For the purposes
          of this License, Derivative Works shall not include works that remain
          separable from, or merely link (or bind by name) to the interfaces of,
          the Work and Derivative Works thereof.
    
          "Contribution" shall mean any work of authorship, including
          the original version of the Work and any modifications or additions
          to that Work or Derivative Works thereof, that is intentionally
          submitted to Licensor for inclusion in the Work by the copyright owner
          or by an individual or Legal Entity authorized to submit on behalf of
          the copyright owner. For the purposes of this definition, "submitted"
          means any form of electronic, verbal, or written communication sent
          to the Licensor or its representatives, including but not limited to
          communication on electronic mailing lists, source code control systems,
          and issue tracking systems that are managed by, or on behalf of, the
          Licensor for the purpose of discussing and improving the Work, but
          excluding communication that is conspicuously marked or otherwise
          designated in writing by the copyright owner as "Not a Contribution."
    
          "Contributor" shall mean Licensor and any individual or Legal Entity
          on behalf of whom a Contribution has been received by Licensor and
          subsequently incorporated within the Work.
    
       2. Grant of Copyright License. Subject to the terms and conditions of
          this License, each Contributor hereby grants to You a perpetual,
          worldwide, non-exclusive, no-charge, royalty-free, irrevocable
          copyright license to reproduce, prepare Derivative Works of,
          publicly display, publicly perform, sublicense, and distribute the
          Work and such Derivative Works in Source or Object form.
    
       3. Grant of Patent License. Subject to the terms and conditions of
          this License, each Contributor hereby grants to You a perpetual,
          worldwide, non-exclusive, no-charge, royalty-free, irrevocable
          (except as stated in this section) patent license to make, have made,
          use, offer to sell, sell, import, and otherwise transfer the Work,
          where such license applies only to those patent claims licensable
          by such Contributor that are necessarily infringed by their
          Contribution(s) alone or by combination of their Contribution(s)
          with the Work to which such Contribution(s) was submitted. If You
          institute patent litigation against any entity (including a
          cross-claim or counterclaim in a lawsuit) alleging that the Work
          or a Contribution incorporated within the Work constitutes direct
          or contributory patent infringement, then any patent licenses
          granted to You under this License for that Work shall terminate
          as of the date such litigation is filed.
    
       4. Redistribution. You may reproduce and distribute copies of the
          Work or Derivative Works thereof in any medium, with or without
          modifications, and in Source or Object form, provided that You
          meet the following conditions:
    
          (a) You must give any other recipients of the Work or
              Derivative Works a copy of this License; and
    
          (b) You must cause any modified files to carry prominent notices
              stating that You changed the files; and
    
          (c) You must retain, in the Source form of any Derivative Works
              that You distribute, all copyright, patent, trademark, and
              attribution notices from the Source form of the Work,
              excluding those notices that do not pertain to any part of
              the Derivative Works; and
    
          (d) If the Work includes a "NOTICE" text file as part of its
              distribution, then any Derivative Works that You distribute must
              include a readable copy of the attribution notices contained
              within such NOTICE file, excluding those notices that do not
              pertain to any part of the Derivative Works, in at least one
              of the following places: within a NOTICE text file distributed
              as part of the Derivative Works; within the Source form or
              documentation, if provided along with the Derivative Works; or,
              within a display generated by the Derivative Works, if and
              wherever such third-party notices normally appear. The contents
              of the NOTICE file are for informational purposes only and
              do not modify the License. You may add Your own attribution
              notices within Derivative Works that You distribute, alongside
              or as an addendum to the NOTICE text from the Work, provided
              that such additional attribution notices cannot be construed
              as modifying the License.
    
          You may add Your own copyright statement to Your modifications and
          may provide additional or different license terms and conditions
          for use, reproduction, or distribution of Your modifications, or
          for any such Derivative Works as a whole, provided Your use,
          reproduction, and distribution of the Work otherwise complies with
          the conditions stated in this License.
    
       5. Submission of Contributions. Unless You explicitly state otherwise,
          any Contribution intentionally submitted for inclusion in the Work
          by You to the Licensor shall be under the terms and conditions of
          this License, without any additional terms or conditions.
          Notwithstanding the above, nothing herein shall supersede or modify
          the terms of any separate license agreement you may have executed
          with Licensor regarding such Contributions.
    
       6. Trademarks. This License does not grant permission to use the trade
          names, trademarks, service marks, or product names of the Licensor,
          except as required for reasonable and customary use in describing the
          origin of the Work and reproducing the content of the NOTICE file.
    
       7. Disclaimer of Warranty. Unless required by applicable law or
          agreed to in writing, Licensor provides the Work (and each
          Contributor provides its Contributions) on an "AS IS" BASIS,
          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
          implied, including, without limitation, any warranties or conditions
          of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
          PARTICULAR PURPOSE. You are solely responsible for determining the
          appropriateness of using or redistributing the Work and assume any
          risks associated with Your exercise of permissions under this License.
    
       8. Limitation of Liability. In no event and under no legal theory,
          whether in tort (including negligence), contract, or otherwise,
          unless required by applicable law (such as deliberate and grossly
          negligent acts) or agreed to in writing, shall any Contributor be
          liable to You for damages, including any direct, indirect, special,
          incidental, or consequential damages of any character arising as a
          result of this License or out of the use or inability to use the
          Work (including but not limited to damages for loss of goodwill,
          work stoppage, computer failure or malfunction, or any and all
          other commercial damages or losses), even if such Contributor
          has been advised of the possibility of such damages.
    
       9. Accepting Warranty or Additional Liability. While redistributing
          the Work or Derivative Works thereof, You may choose to offer,
          and charge a fee for, acceptance of support, warranty, indemnity,
          or other liability obligations and/or rights consistent with this
          License. However, in accepting such obligations, You may act only
          on Your own behalf and on Your sole responsibility, not on behalf
          of any other Contributor, and only if You agree to indemnify,
          defend, and hold each Contributor harmless for any liability
          incurred by, or claims asserted against, such Contributor by reason
          of your accepting any such warranty or additional liability.
    
       END OF TERMS AND CONDITIONS
    
       APPENDIX: How to apply the Apache License to your work.
    
          To apply the Apache License to your work, attach the following
          boilerplate notice, with the fields enclosed by brackets "[]"
          replaced with your own identifying information. (Don't include
          the brackets!)  The text should be enclosed in the appropriate
          comment syntax for the file format. We also recommend that a
          file or class name and description of purpose be included on the
          same "printed page" as the copyright notice for easier
          identification within third-party archives.
    
       Copyright [yyyy] [name of copyright owner]
    
       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at
    
           http://www.apache.org/licenses/LICENSE-2.0
    
       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
       
       ````



