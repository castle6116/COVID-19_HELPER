//
//  GeneralForumViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/15.
//

import UIKit

import Alamofire

class GeneralForumViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var ForumTable: UITableView!
    
    var tableContent = [Forum_list]()
    var id : Int?
    var pageNum = 0
    var totalPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        StartSetting()
        // Do any additional setup after loading the view.
    }
    
    func StartSetting(){

        
        ForumTable.delegate = self
        ForumTable.dataSource = self
        ForumTableGet(){
            table in
            if let table = table{
                self.totalPage = table.result_data.totalPage
                for a in table.result_data.data{
                    self.tableContent.append(a)
                }
                DispatchQueue.main.async {
                    self.ForumTable.reloadData()
                    self.pageNum += 1
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func ForumTableGet(complation : ((GeneralForum?) -> ())?){
        let url = "http://test.byeonggook.shop/api/board/boardList"
        AF.request(url,
                   method: .post,
                   parameters: ["page" : pageNum, "size" :10],
                   encoding: URLEncoding.default
        )
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
                        let getInstanceData = try JSONDecoder().decode(GeneralForum.self, from: dataJSON)
    //                        print("예방 접종 현황 : ",getInstanceData)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("게시판 목록 가져오기 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("게시판 목록 가져오기 에러 : ",error.localizedDescription)
            }
        }
    }
}

extension GeneralForumViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = ForumTable.dequeueReusableCell(withIdentifier: "ForumCell", for: indexPath) as? GeneralForumTableViewCell else {
                    return UITableViewCell()
                }
        
        cell.Date.text = tableContent[indexPath.row].createdDate
        cell.Title.text = tableContent[indexPath.row].title
        cell.Content.text = tableContent[indexPath.row].content
        cell.GoodCount.text = String(tableContent[indexPath.row].recommend)
        cell.Reword.text = String(tableContent[indexPath.row].deprecate)
        cell.ViewCount.text = String(tableContent[indexPath.row].hit)
        cell.reviewCount.text = String(tableContent[indexPath.row].review_count)
        cell.ControlView.layer.borderWidth = 2
        cell.ControlView.layer.borderColor = CGColor.init(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        cell.ControlView.layer.cornerRadius = 15
        cell.selectionStyle = .none
        cell.ControlView.backgroundColor = .white
        
        cell.contentView.layer.shadowColor = UIColor.black.cgColor // 검정색 사용
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 1) // 반경에 대해서 너무 적용이 되어서 4point 정도 ㅐ림.
        cell.contentView.layer.shadowRadius = 3 // 반경?
        cell.contentView.layer.shadowOpacity = 0.3 // alpha값입니다.
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "DetailView", sender: tableContent[indexPath.row].id)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let Viewcont = segue.destination as? DetailForumViewController, let HolyValue = sender as? Int else {return}
        Viewcont.DabValue = HolyValue
        print(Viewcont.DabValue!)
    }
    
    
}

extension GeneralForumViewController : UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 마지막 셀일때 다시 통신 해서 값 받아와야한다.
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            //업데이트하고싶은 action 구현
            if (totalPage - 1) >= pageNum{
                ForumTableGet(){
                    table in
                    if let table = table{
                        for a in table.result_data.data{
                            self.tableContent.append(a)
                        }
                        self.tableContent.sort(by: {
                            $0.createdDate > $1.createdDate
                        })
                        DispatchQueue.main.async {
                            self.ForumTable.reloadData()
                            self.pageNum += 1
                        }
                    }
                }
            }
            
        }
    }
}
