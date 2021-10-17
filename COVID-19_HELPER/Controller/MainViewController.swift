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
    
    var result : Covid!
    var desult : City!
    var Covidresult : [Covid] = []
    var Coviddesult : [City] = []
    var elementValue:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        COVID_CONNECT(day: -1)
        COVID_Desult_CONNECT()
        // Do any additional setup after loading the view.
    }
    
    func DecimalWon(value: Int) -> String{
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
            clfy.text = "(\(DecimalWon(value: Int(Covidresult[0].careCnt!)!)))" //치료
            ghkrwls.text = "(\(DecimalWon(value: (Int(Covidresult[0].decideCnt)! - Int(Covidresult[1].decideCnt)!))))" //일일 확진
            today_cure.text = "(\(DecimalWon(value: (Int(Covidresult[0].clearCnt)! - Int(Covidresult[1].clearCnt)!))))" //일일 완치
            
            rurflout.text = DecimalWon(value: Int(Covidresult[0].clearCnt)!) //격리 해제
            rjatk.text = DecimalWon(value: Int(Covidresult[0].examCnt)!) //검사
            tkakd.text = DecimalWon(value: Int(Covidresult[0].deathCnt)!) //사망
            snwjrrjatk.text = DecimalWon(value: Int(Covidresult[0].accExamCnt)!) //누적검사
            snwjrdhksfy.text = DecimalWon(value: Int(Covidresult[0].resutlNegCnt)!) //결과 음성
            snwjrghkrwls.text = DecimalWon(value: Int(Covidresult[0].decideCnt)!) // 누적확진
            
            
            ghkrwls_today.text = "(+\(DecimalWon(value: (Int(Covidresult[0].decideCnt)! - Int(Covidresult[1].decideCnt)!))))"   // 확진환자 금일 증가수
            rurflgowp_today.text = "(+\(DecimalWon(value: (Int(Covidresult[0].clearCnt)! - Int(Covidresult[1].clearCnt)!))))"// 격리해제 금일 증가수
            dead_today.text = "(+\(DecimalWon(value: (Int(Covidresult[0].deathCnt)! - Int(Covidresult[1].deathCnt)!))))"     // 사망자 금일 증가수
            snwjrrjatk_today.text = "(+\(DecimalWon(value: (Int(Covidresult[0].accExamCnt)! - Int(Covidresult[1].accExamCnt)!))))"// 누적 검사 수 금일 증가수
            rjatkwnd_today!.text = "(+\(DecimalWon(value: (Int(Covidresult[0].examCnt)! - Int(Covidresult[1].examCnt)!))))" // 검사중 금일 증가수
            rufrhkdmatjd_today.text =  "(+\(DecimalWon(value: (Int(Covidresult[0].resutlNegCnt)! - Int(Covidresult[1].resutlNegCnt)!))))"  // 결과음성 금일 증가수
        }
    }
    
    func COVID_CONNECT (day : Int){
        let fomat_today = DateFormatter()
        fomat_today.dateFormat = "yyyyMMdd"
        fomat_today.locale = Locale(identifier: "ko")
        let today_data = Date()
        var today = fomat_today.string(from: today_data)
        var test = Calendar.current.date(byAdding: .day, value: day, to: today_data)!
        var yesterday = fomat_today.string(from: test)
        let url = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?startCreateDt=\(yesterday)&endCreateDt=\(today)&serviceKey=2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz%2F1j863w%3D%3D"
        let request = XMLParser(contentsOf: URL(string: url)!)
        request!.delegate = self
        let success = request!.parse()
        if success == true{
            print("파싱 성공")
            if Covidresult.count != 2{
                COVID_CONNECT(day: -2)
            }
            textinput()
        }else{
            print("파싱 실패")
        }
    }
    
    func COVID_Desult_CONNECT (){
        let url = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey=2ruJcuSknJSbxInurJjb5i2sTGvCPW8QkHSBqOMUWvGyim3ASZFwWUGssNAQ8Ga9qCtqJQgX2Hnlwgz%2F1j863w%3D%3D"
        let request = XMLParser(contentsOf: URL(string: url)!)
        request!.delegate = self
        let success = request!.parse()
        if success == true{
            print("파싱 성공")
            Coviddesult.sort{Int($0.defCnt!)! > Int($1.defCnt!)!}
            print(Coviddesult[0].defCnt!)
        }else{
            print("파싱 실패")
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName == "item"{
                var dic = attributeDict as Dictionary
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
        cell.iso_ingCnt.text = Coviddesult[indexPath.row].isoIngCnt // 격리중
        cell.Def_cnt.text = Coviddesult[indexPath.row].defCnt // 확진 환자
        if Coviddesult[indexPath.row].incDec != nil{
            cell.Inc_dec.text = "+\(Coviddesult[indexPath.row].incDec!)" // 전일 대비
        }
        cell.iso_ClearCnt.text = Coviddesult[indexPath.row].isoClearCnt //격리 해제
        cell.death_cnt.text = Coviddesult[indexPath.row].deathCnt // 사망자
        cell.collection_view.layer.borderWidth = 1
        cell.collection_view.layer.borderColor = CGColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1.0)
        cell.collection_view.layer.cornerRadius = 15
        cell.layer.cornerRadius = 10
//                let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
//                cell.imgView?.image = img
//                cell.nameLabel?.text = nameList[indexPath.row]
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
