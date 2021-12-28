//
//  ChartsViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/12/27.
//

import UIKit
import Charts
import DropDown

class ChartsViewController: UIViewController {
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var menu: UIButton!
    @IBAction func menuButton(_ sender: Any) {
        dropDown.show()
        dropDown.anchorView = menu
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = Array(Set(gubun)).sorted{$0 < $1}
        dropDown.width = 100
        dropDown.selectedTextColor = .gray
        dropDown.cornerRadius = 15
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            location = item
            setStarting()
            
        }
        
    }
    
    var location = ""
    var Controller = MainViewController()
    var months: [String] = []
    var unitsSold: [String] = []
    var before = "0"
    var gubun = [String]()
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStarting()
        
    }
    
    func setStarting(){
        months = []
        unitsSold = []
        before = "0"
        
        menu.setTitle(location , for: .normal)
        Controller.COVID_Desult_CONNECT(day: -7)
        Controller.Coviddesult.sort{
            $0.createDt < $1.createDt
        }
        Controller.Coviddesult = Controller.Coviddesult.filter{
            gubun.append($0.gubun)
            if $0.gubun == location{
                return true
            }
            return false
        }
        
        before = Controller.Coviddesult[0].defCnt
        
        for a in 1 ..< Controller.Coviddesult.count{
            let result : Int = Int(Controller.Coviddesult[a].defCnt)! - Int(before)!
            unitsSold.append(String(result))
            before = Controller.Coviddesult[a].defCnt
            
            let startIdx: String.Index = Controller.Coviddesult[a].createDt.index(Controller.Coviddesult[a].createDt.startIndex, offsetBy: 5)
            let endIdx: String.Index = Controller.Coviddesult[a].createDt.index(Controller.Coviddesult[a].createDt.startIndex, offsetBy: 10)
            let stringResult = String(Controller.Coviddesult[a].createDt[startIdx...endIdx])
            
            months.append(stringResult)
        }
               
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        setChart(dataPoints: months, values: unitsSold, gubun: location)
        
        dropDown.dataSource = [""]
    }
    
    func setChart(dataPoints: [String], values: [String], gubun : String) {
        
        // 데이터 생성
        var dataEntries: [BarChartDataEntry] = []
        
        dataEntries = []
        barChartView.data = nil
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "확진 환자 수")
        
        // 차트 컬러
        chartDataSet.colors = [.systemBlue]
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData

        // X축 레이블 위치 조정
        barChartView.xAxis.labelPosition = .bottom
        // X축 레이블 포맷 지정
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)

        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 오른쪽 레이블 제거
        barChartView.rightAxis.enabled = false
        
        // 기본 애니메이션
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // 옵션 애니메이션
        //barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
    }

}
