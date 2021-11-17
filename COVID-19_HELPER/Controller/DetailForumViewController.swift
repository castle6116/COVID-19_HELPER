//
//  DetailForumViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import UIKit

import Alamofire

class DetailForumViewController: UIViewController {
    
    @IBOutlet weak var Collection: UICollectionView!
    
    /// 게시글 ID 넘어오는 값
    var DabValue : Int!
    
    var Board = board()
    override func viewDidLoad() {
        super.viewDidLoad()
        Collection.delegate = self
        Collection.dataSource = self
        ForumTableGet(boardNum: DabValue){
            list in
            if let list = list {
                self.Board = list.result_data.account
                DispatchQueue.main.async {
                    self.Collection.reloadData()
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    // 게시글 세부 내용 출력
    func ForumTableGet(boardNum : Int ,complation : ((boardList?) -> ())?){
        let url = "http://test.byeonggook.shop/api/board/\(boardNum)"
        AF.request(url,
                   method: .get,
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
                        let getInstanceData = try JSONDecoder().decode(boardList.self, from: dataJSON)
    //                        print("예방 접종 현황 : ",getInstanceData)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("게시글 가져오기 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("게시글 가져오기 에러 : ",error.localizedDescription)
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

}

extension DetailForumViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // 바디 뷰 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // 바디 뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 셀 하나의 너비
        let width: CGFloat = collectionView.frame.width
        
        // 셀 하나의 높이
        let height: CGFloat = 140

        return CGSize(width: width, height: height)
    }
    
    // 바디 뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionBody", for: indexPath) as? UseCollection else {
                    return UICollectionViewCell()
                }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 15
        cell.layer.backgroundColor = .none
        return cell
    }
    
    // 헤더 뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! BoardHeader
        let height = headerView.Content.text?.heightWithConstrainedWidth(font: UIFont.systemFont(ofSize: 17)) ?? 0
        return CGSize(width: collectionView.frame.size.width, height: height + 220)
    }

    //헤더 뷰 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath) as! BoardHeader
        print(self.Board)
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = UIColor.darkGray.cgColor
        headerView.layer.cornerRadius = 15
        
        headerView.Title.text = Board.title
        headerView.Content.text = Board.content
        headerView.NickName.text = Board.nickname
        headerView.Count.text = String(Board.hit ?? 10)
        headerView.GoodButton.setTitle(String(Board.recommend ?? 10), for: .normal)
        headerView.NotGoodButton.setTitle(String(Board.deprecate ?? 10), for: .normal)
        
        headerView.Content.lineBreakStrategy = .hangulWordPriority
        headerView.GoodButton.layer.cornerRadius = 15
        headerView.NotGoodButton.layer.cornerRadius = 15
        
        return headerView
    }
    
}

extension String {
    func heightWithConstrainedWidth(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.height
    }
}
