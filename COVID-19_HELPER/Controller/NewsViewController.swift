//
//  NewsViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/10/18.
//

import UIKit

import Alamofire
import KeychainSwift

class NewsViewController: LoadingView, UIScrollViewDelegate {
    @IBOutlet var tableview_Custom: UITableView!
    var refreshControl = UIRefreshControl()
    var display = 20
    var start = 1
    var test = [Items]()
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        startUI()
        // Do any additional setup after loading the view.
    }
    func startUI(){
        tableview_Custom.delegate = self
        tableview_Custom.dataSource = self
        tableview_Custom.rowHeight = 120
        naverNewsRequest(Query: "코로나", Display: display, Start: start){
            news in
            if let news = news{
                for a in 0..<news.items.count{
                    self.test.append(news.items[a])
                }
            }
            DispatchQueue.main.async {
                self.tableview_Custom.reloadData()
            }
            self.hideLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "뉴스 상황판"
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset

        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height

        let reloadDistance = CGFloat(30.0)
        if y > h + reloadDistance {
            if start <= 100{
                start += display
                naverNewsRequest(Query: "코로나", Display: display, Start: start){
                    news in
                    if let news = news{
                        for a in 0..<news.items.count{
                            self.test.append(news.items[a])
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableview_Custom.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        print(test.count)
        
    }
    
    func naverNewsRequest(Query : String, Display : Int , Start : Int, complation : ((News?) -> ())?){
        let url = "https://openapi.naver.com/v1/search/news.json"
//        let param : Parameters = ["query" : Query, "display" : String(Display), "start" : String(Start) , "sort" : "sim"]// JSON 객체로 변환할 딕셔너리 준비
        KeychainSwift().set("1wHBeYSHxL7BTO6QkY7i",forKey: "X-Naver-Client-Id")
        KeychainSwift().set("xiEh2WMJ8d",forKey: "X-Naver-Client-Secret")
        let headers : HTTPHeaders = ["X-Naver-Client-Id" : KeychainSwift().get("X-Naver-Client-Id")!, "X-Naver-Client-Secret" : KeychainSwift().get("X-Naver-Client-Secret")!,
            "Content-Type":"application/json; charset=utf-8",
            "Accept":"application/json"]
        AF.request(url,
                   method: .get,
                   parameters: ["query" : Query, "display" : String(Display), "start" : String(Start) , "sort" : "sim"],
                   encoding: URLEncoding.default,
                   headers: headers)
            .responseJSON{
                (response) in
//            let statusCode = response.response?.statusCode
            switch response.result{
            case .success(let obj):
//                obj = String(data: response.data!, encoding: .utf8)
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(News.self, from: dataJSON)
//                        print("네이버 뉴스 데이터 : ",getInstanceData)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("네이버 뉴스 에러 반환 : ",error)
                    }
                }
            case.failure(let error):
                print("Error : ",error.localizedDescription)
            }
        }
    }
    
}

extension NewsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview_Custom.dequeueReusableCell(withIdentifier: "NewsCell", for : indexPath ) as! NewsTableViewCell
        
        let titlefont = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        cell.Content.numberOfLines = 3
        cell.Content.lineBreakStrategy = .hangulWordPriority
        
        let fomat_today = DateFormatter()
        fomat_today.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        fomat_today.locale = Locale(identifier: "en_US")
        fomat_today.timeZone = TimeZone(abbreviation: "UTC")
        var text = fomat_today.date(from: test[indexPath.row].pubDate)!
        
        let fomat_today_days = DateFormatter()
        fomat_today_days.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        fomat_today_days.locale = Locale(identifier: "ko_KR")
        cell.Title.attributedText = test[indexPath.row].title.htmlEscaped(font: titlefont, colorHex: "#000000", lineSpacing: 1)
        cell.Content.attributedText = test[indexPath.row].description.htmlEscaped(font: font, colorHex: "#999A9A", lineSpacing: 1)
        cell.Day.text = fomat_today_days.string(from: text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(URL(string: test[indexPath.row].link)!, options: [:])
    }
    
}

extension String {
    func htmlEscaped(font: UIFont, colorHex: String, lineSpacing: CGFloat) -> NSAttributedString {
        let style = """
                    <style>
                    p.normal {
                      line-height: \(lineSpacing);
                      font-size: \(font.pointSize)px;
                      font-family: \(font.familyName);
                      color: \(colorHex);
                    }
                    </style>
        """
        let modified = String(format:"\(style)<p class=normal>%@</p>", self)
        do {
            guard let data = modified.data(using: .unicode) else {
                return NSAttributedString(string: self)
            }
            let attributed = try NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html],
                                                    documentAttributes: nil)
            return attributed
        } catch {
            return NSAttributedString(string: self)
        }
    }
}
