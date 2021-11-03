//
//  ViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/09.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, XMLParserDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var rlwns: UILabel! //기준일
    @IBOutlet var ghkrwls: UILabel! // 일일 확진자
    @IBOutlet var clfy: UILabel! // 격리중 ( 치료자 )
    @IBOutlet var today_cure: UILabel! // 일일 완치
    @IBOutlet var rurflout: UILabel! //격리 해제
    @IBOutlet var rjatk: UILabel! //검사중
    @IBOutlet var tkakd: UILabel! //사망자
    @IBOutlet var snwjrrjatk: UILabel! // 누적검사수
    @IBOutlet var snwjrdhksfy: UILabel! // 결과음성
    @IBOutlet var snwjrghkrwls: UILabel! // 확진환자
    
    @IBOutlet var ghkrwls_today: UILabel!   // 확진환자 금일 증가수
    @IBOutlet var rurflgowp_today: UILabel! // 격리해제 금일 증가수
    @IBOutlet var dead_today: UILabel!      // 사망자 금일 증가수
    @IBOutlet var snwjrrjatk_today: UILabel!// 누적 검사 수 금일 증가수
    @IBOutlet var rjatkwnd_today: UILabel!  // 검사중 금일 증가수
    @IBOutlet var rufrhkdmatjd_today: UILabel!  // 결과음성 금일 증가수
    @IBOutlet var city_daily: UILabel!
    @IBOutlet var MainScroll: UIScrollView!
    @IBOutlet var City_Collection: UICollectionView!
    
    var result : Covid!
    var desult : City!
    var Covidresult : [Covid] = []
    var Coviddesult : [City] = []
    var elementValue:String!
    var Covid_day = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DidLoad")
        COVID_CONNECT(day: Covid_day)
        Covid_day = 0
        COVID_Desult_CONNECT(day : Covid_day)
        
        initRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "코로나19 상황판"
    }
            
    // UIRefreshControl 초기 설정
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
         
        if #available(iOS 10.0, *) {
            MainScroll.refreshControl = refresh
        }
    }
            
    // 새로고침 함수
    @objc func updateUI(refresh: UIRefreshControl) {
        print("새로고침")
        Covidresult = []
        Coviddesult = []
        COVID_CONNECT(day: Covid_day)
        Covid_day = 0
        COVID_Desult_CONNECT(day : Covid_day)
        DispatchQueue.main.async {
            self.City_Collection.reloadData()
            print("돌았당")
        }
        
        refresh.endRefreshing() // 리프레쉬 종료
    }
    
    // , 찍어주는 함수
    func DecimalWon(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
            
        return result
    }
    // , 찍어주는 함수
    func DecimalWon(value: Int, cot: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        if value > 0 {
            return "+" + result
        }
            
        return result
    }
    // , 찍어주는 함수
    func DecimalWon(value: String) -> String{
        let value = Int(value)!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        if value > 0 {
            return "+" + result
        }
        
        return result
    }
    // , 찍어주는 함수
    func DecimalWon(value: String, cot: Int) -> String{
        let value = Int(value)!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        return result
    }
    
    func textinput(){
        if result != nil{
            let start = Covidresult[0].createDt.startIndex
            let end = Covidresult[0].createDt.index(result.createDt.startIndex, offsetBy: 10)
            let sub = Covidresult[0].createDt[start...end]
            rlwns.text = "( \(String(sub)) 기준 )" // 기준일
            clfy.text = "(\(DecimalWon(value: Int(Covidresult[0].careCnt!)!, cot: 0)))" //치료
            ghkrwls.text = "(\(DecimalWon(value: (Int(Covidresult[0].decideCnt)! - Int(Covidresult[1].decideCnt)!), cot: 0)))" //일일 확진
            today_cure.text = "(\(DecimalWon(value: (Int(Covidresult[0].clearCnt)! - Int(Covidresult[1].clearCnt)!), cot: 0)))" //일일 완치
            
            rurflout.text = DecimalWon(value: Int(Covidresult[0].clearCnt)!) //격리 해제
            rjatk.text = DecimalWon(value: Int(Covidresult[0].examCnt)!) //검사
            tkakd.text = DecimalWon(value: Int(Covidresult[0].deathCnt)!) //사망
            snwjrrjatk.text = DecimalWon(value: Int(Covidresult[0].accExamCnt)!) //누적검사
            snwjrdhksfy.text = DecimalWon(value: Int(Covidresult[0].resutlNegCnt)!) //결과 음성
            snwjrghkrwls.text = DecimalWon(value: Int(Covidresult[0].decideCnt)!) // 누적확진
            
            
            ghkrwls_today.text = "(\(DecimalWon(value: (Int(Covidresult[0].decideCnt)! - Int(Covidresult[1].decideCnt)!), cot: 0)))"   // 확진환자 금일 증가수
            rurflgowp_today.text = "(\(DecimalWon(value: (Int(Covidresult[0].clearCnt)! - Int(Covidresult[1].clearCnt)!), cot: 0)))"// 격리해제 금일 증가수
            dead_today.text = "(\(DecimalWon(value: (Int(Covidresult[0].deathCnt)! - Int(Covidresult[1].deathCnt)!), cot: 0)))"     // 사망자 금일 증가수
            snwjrrjatk_today.text = "(\(DecimalWon(value: (Int(Covidresult[0].accExamCnt)! - Int(Covidresult[1].accExamCnt)!), cot: 0)))"// 누적 검사 수 금일 증가수
            rjatkwnd_today!.text = "(\(DecimalWon(value: (Int(Covidresult[0].examCnt)! - Int(Covidresult[1].examCnt)!), cot: 0)))" // 검사중 금일 증가수
            rufrhkdmatjd_today.text =  "(\(DecimalWon(value: (Int(Covidresult[0].resutlNegCnt)! - Int(Covidresult[1].resutlNegCnt)!), cot: 0)))"  // 결과음성 금일 증가수
        }
    }
    
    // 코로나 확진자 현황 HTTP 통신 부문
    func COVID_CONNECT (day : Int){
        let fomat_today = DateFormatter()
        fomat_today.dateFormat = "yyyyMMdd"
        fomat_today.locale = Locale(identifier: "ko")
        let today_data = Date()
        let today = fomat_today.string(from: today_data)
        let test = Calendar.current.date(byAdding: .day, value: day, to: today_data)!
        let yesterday = fomat_today.string(from: test)
        let url = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?startCreateDt=\(yesterday)&endCreateDt=\(today)&serviceKey=2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz%2F1j863w%3D%3D"
        let request = XMLParser(contentsOf: URL(string: url)!)
        request!.delegate = self
        let success = request!.parse()
        if success == true{
            print("대한민국 감염현황 파싱 성공")
            print(Covidresult.count)
            print(Covid_day)
            if Covidresult.count < 2{
                Covidresult = []
                Covid_day -= 1
                COVID_CONNECT(day: Covid_day)
                print(Covid_day)
            }
            textinput()
        }else{
            print("파싱 실패")
        }
    }
    
    func COVID_Desult_CONNECT (day: Int){
        let fomat_today = DateFormatter()
        fomat_today.dateFormat = "yyyyMMdd"
        fomat_today.locale = Locale(identifier: "ko")
        let today_data = Date()
        let today = fomat_today.string(from: today_data)
        let test = Calendar.current.date(byAdding: .day, value: day, to: today_data)!
        let yesterday = fomat_today.string(from: test)
        
        let url = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey=2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz%2F1j863w%3D%3D&startCreateDt=\(yesterday)&endCreateDt=\(today)"
        let request = XMLParser(contentsOf: URL(string: url)!)
        request!.delegate = self
        let success = request!.parse()
        if success == true{
            print("지역 감염현황 파싱 성공")
            Coviddesult.sort{Int($0.defCnt!)! > Int($1.defCnt!)!}
            if Coviddesult.count != 19{
                Coviddesult = []
                Covid_day -= 1
                COVID_Desult_CONNECT(day: Covid_day)
                print(Covid_day)
            }
            city_daily.text = "\(Coviddesult[0].stdDay!) 업데이트"
        }else{
            print("파싱 실패")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName == "item"{
                let dic = attributeDict as Dictionary
                result = Covid()
                desult = City()
                if dic["gubun"] == nil{
                    result.accDefRate = dic["accDefRate"]
                    result.accExamCnt = dic["accExamCnt"]
                    result.accExamCompCnt = dic["accExamCompCnt"]
                    result.careCnt = dic["careCnt"]
                    result.clearCnt = dic["clearCnt"]
                    result.createDt = dic["createDt"]
                    result.deathCnt = dic["deathCnt"]
                    result.decideCnt = dic["decideCnt"]
                    result.examCnt = dic["examCnt"]
                    result.stateDt = dic["stateDt"]
                    result.resutlNegCnt = dic["resutlNegCnt"]
                }else{
                    desult.deathCnt = dic["deathCnt"]
                    desult.defCnt = dic["defCnt"]
                    desult.gubun = dic["gubun"]
                    desult.incDec = dic["incDec"]
                    desult.isoClearCnt = dic["isolClearCnt"]
                    desult.isoIngCnt = dic["isolIngCnt"]
                    desult.stdDay = dic["stdDay"]
                }
            }
        }
        
        // 현재 테그에 담겨있는 문자열 전달
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if elementValue == nil{
                elementValue = string
            }else{
                elementValue = "\(elementValue!)\(string)"
            }
        }
        
        // XML 파서가 종료 테그를 만나면 호출됨
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item"{
                guard let result = result else {
                    return
                }
                Covidresult.append(result)
                guard let desult = desult else {
                    return
                }
                if desult.defCnt != nil{
                    Coviddesult.append(desult)
                }
            }else if elementName == "accDefRate"{
                result.accDefRate = elementValue!
            }else if elementName == "accExamCnt"{
                result.accExamCnt = elementValue!
            }else if elementName == "accExamCompCnt"{
                result.accExamCompCnt = elementValue!
            }else if elementName == "careCnt"{
                result.careCnt = elementValue!
            }else if elementName == "clearCnt"{
                result.clearCnt = elementValue!
            }else if elementName == "createDt"{
                result.createDt = elementValue!
            }else if elementName == "deathCnt"{
                result.deathCnt = elementValue!
                desult.deathCnt = elementValue!
            }else if elementName == "decideCnt"{
                result.decideCnt = elementValue!
            }else if elementName == "examCnt"{
                result.examCnt = elementValue!
            }else if elementName == "stateDt"{
                result.stateDt = elementValue!
            }else if elementName == "stateTime"{
                result.stateTime = elementValue!
            }else if elementName == "resutlNegCnt"{
                result.resutlNegCnt = elementValue!
            }else if elementName == "defCnt"{
                desult.defCnt = elementValue!
            }
            else if elementName == "gubun"{
                desult.gubun = elementValue!
            }
            else if elementName == "incDec"{
                desult.incDec = elementValue!
            }
            else if elementName == "isolClearCnt"{
                desult.isoClearCnt = elementValue!
            }
            else if elementName == "isolIngCnt"{
                desult.isoIngCnt = elementValue!
            }
            else if elementName == "stdDay"{
                desult.stdDay = elementValue!
            }
            elementValue = nil
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing: CGFloat = 10 // 가로에서 cell과 cell 사이의 거리
        let width: CGFloat = (collectionView.frame.width - itemSpacing) / 2 // 셀 하나의 너비
        let height: CGFloat = width + 20 //셀 하나의 높이
        print(width)

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Coviddesult.count // 여기에 배열 크기 반환
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "left_cell", for: indexPath) as? CollectionViewCell else {
                    return UICollectionViewCell()
                }
        cell.backgroundColor = .white
        cell.collection_subject?.text = Coviddesult[indexPath.row].gubun
        cell.iso_ingCnt.text = DecimalWon(value: Coviddesult[indexPath.row].isoIngCnt, cot: 0) // 격리중
        cell.Def_cnt.text = DecimalWon(value: Coviddesult[indexPath.row].defCnt, cot: 0) // 확진 환자
        if Coviddesult[indexPath.row].incDec != nil{
            cell.Inc_dec.text = "\(DecimalWon(value: Coviddesult[indexPath.row].incDec!))" // 전일 대비
        }
        cell.iso_ClearCnt.text = DecimalWon(value: Coviddesult[indexPath.row].isoClearCnt, cot: 0) //격리 해제
        cell.death_cnt.text = DecimalWon(value: Coviddesult[indexPath.row].deathCnt, cot: 0) // 사망자
        cell.collection_view.layer.borderWidth = 1
        cell.collection_view.layer.borderColor = CGColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1.0)
        cell.collection_view.layer.cornerRadius = 15
        cell.layer.cornerRadius = 10
        return cell
    }
    
    
}

class CollectionViewCell: UICollectionViewCell{
    @IBOutlet var collection_subject: UILabel!
    @IBOutlet var collection_view: UIView!
    @IBOutlet var iso_ingCnt: UILabel!
    @IBOutlet var Def_cnt: UILabel!
    @IBOutlet var Inc_dec: UILabel!
    @IBOutlet var iso_ClearCnt: UILabel!
    @IBOutlet var death_cnt: UILabel!
}
