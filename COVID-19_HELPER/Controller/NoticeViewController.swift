//
//  NoticeViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/04.
//

import UIKit
import Alamofire

class NoticeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var NoticeList_All = [NoticeList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NoticeAllRequest(){
            notice in
            if let notice = notice{
                for a in notice.result_data.data{
                    self.NoticeList_All.append(a)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func NoticeAllRequest(complation : ((Notice?) -> ())?){
        let url = "http://test.byeonggook.shop/api/notice/noticeList"
        let headers : HTTPHeaders = ["Content-Type":"application/json; charset=utf-8","Accept":"application/json"]
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
            .responseJSON{
                (response) in
//            let statusCode = response.response?.statusCode
            switch response.result{
            case .success(let obj):
//                obj = String(data: response.data!, encoding: .utf8)
                print("공지사항 GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(Notice.self, from: dataJSON)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("공지사항 에러 반환 : ",error)
                    }
                }
            case.failure(let error):
                print("Error : ",error.localizedDescription)
            }
        }
    }
//    test.byeonggook.shop/api/notice/noticeList
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoticeViewController : UITableViewDataSource, UITableViewDelegate{
    //section 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return NoticeList_All.count
        
    }
    //cell 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NoticeList_All[section].open == true {
            return 1 + 1
            
        }else{
            return 1
            
        }
        
    }
    //cell 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTitle", for: indexPath) as? NoticeTableTitleCell else {return UITableViewCell()}
            cell.Title.text = NoticeList_All[indexPath.section].title
            if #available(iOS 14.0, *) {
                cell.Title.lineBreakStrategy = .hangulWordPriority
            }
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeContent", for: indexPath) as? NoticeTableContentCell else {return UITableViewCell()}
            cell.Title.text = NoticeList_All[indexPath.section].title
            cell.Content.text = NoticeList_All[indexPath.section].content
            if #available(iOS 14.0, *) {
                cell.Title.lineBreakStrategy = .hangulWordPriority
                cell.Content.lineBreakStrategy = .hangulWordPriority
            }
            cell.Date.text = NoticeList_All[indexPath.section].modifiedDate
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoticeTableTitleCell else {return}
        guard let index = tableView.indexPath(for: cell) else { return }
        if index.row == indexPath.row {
            if index.row == 0 {
                if NoticeList_All[indexPath.section].open == true {
                    NoticeList_All[indexPath.section].open = false
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                    
                }else {
                    NoticeList_All[indexPath.section].open = true
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                }
            }
        }
    }

}
