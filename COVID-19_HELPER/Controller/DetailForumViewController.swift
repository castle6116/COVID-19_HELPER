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
    @IBOutlet weak var FooterView: BoardFooter!
    private let buttonPanelView = ButtonPanelView()
    /// 게시글 ID 넘어오는 값
    var DabValue : Int!
    
    var Board = board()
    var comment = [Comment_data]()
    var keyboardcount = 0
    var keyhieght :CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        StartSetting()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    func StartSetting(){
        Collection.delegate = self
        Collection.dataSource = self
        FooterView.NickName.delegate = self
        FooterView.Content.delegate = self
        FooterView.PassWord.delegate = self
        FooterView.layer.borderColor = UIColor.darkGray.cgColor
        FooterView.layer.borderWidth = 1
        FooterView.layer.cornerRadius = 15
        FooterView.backgroundColor = UIColor.white
        FooterView.PassWord.isSecureTextEntry = true
        FooterView.Submit.addTarget(self, action: #selector(submitTouch), for: .touchUpInside)
        // 게시글 세부 내용 받아오기
        ForumTableGet(boardNum: DabValue){
            list in
            if let list = list {
                self.Board = list.result_data.account
                DispatchQueue.main.async {
//                    self.setupFlowLayout()
                    self.Collection.reloadData()
                }
            }
            
        }
        // 댓글 내용 받아오기
        CommentListGet(){
            list in
            if let list = list{
                for a in list.result_data.data{
                    self.comment.append(a)
                }
                DispatchQueue.main.async {
//                    self.setupFlowLayout()
                    self.Collection.reloadData()
                }
            }
        }

    }
    
    // 게시글 추천 버튼 클릭
    @objc func GoodButton(_ sender: Any) {
        GoodButtonClick(value: 0, commentNum: 0){
            list in
            if list?.code == 0{
                self.ForumTableGet(boardNum: self.DabValue){
                    list in
                    if let list = list {
                        self.Board = list.result_data.account
                        DispatchQueue.main.async {
                            self.Collection.reloadData()
                        }
                    }
                    self.showToast(message: "추천에 성공 하셨습니다")
                }
            }else{
                self.showToast(message: list!.error!)
            }
        }
    }
    // 게시글 비추천 버튼 클릭
    @objc func NotGoodButton(_ sender: Any) {
        NotGoodButtonClick(value: 0, commentNum: 0){
            list in
            if list?.code == 0{
                self.ForumTableGet(boardNum: self.DabValue){
                    list in
                    if let list = list {
                        self.Board = list.result_data.account
                        DispatchQueue.main.async {
                            self.Collection.reloadData()
                        }
                    }
                    self.showToast(message: "비추천에 성공 하셨습니다")
                }
            }else{
                self.showToast(message: list!.error!)
            }
        }
    }
    // 게시글 신고 버튼 클릭
    func DeclarationButtonClick() {
        CommentDcButtonClick(value: 0, commentNum: 0){
            list in
            if list?.code == 0{
                self.CommentListGet(){
                    list in
                    if let list = list{
                        self.comment = []
                        for a in list.result_data.data{
                            self.comment.append(a)
                        }
                        DispatchQueue.main.async {
                            self.Collection.reloadData()
                        }
                        self.showToast(message: "게시글 신고에 성공 하셨습니다")
                        print(list.result_data.data)
                    }
                }
            }else{
                self.showToast(message: list!.error!)
            }
        }
    }
    // 레이아웃 설정
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
            
//        flowLayout.minimumInteritemSpacing = 10
//        flowLayout.minimumLineSpacing = 10
            
        let Width = Collection.frame.size.width
        flowLayout.itemSize = CGSize(width: Width, height: 80)
        flowLayout.footerReferenceSize = CGSize(width: Width, height: 80)
        flowLayout.sectionFootersPinToVisibleBounds = true
        self.Collection.collectionViewLayout = flowLayout
    }
    
    // 토스트 바 출력
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 17)) {
        let toastLabel = UILabel(frame: CGRect(
            x: self.view.frame.size.width/2 - 150,
            y: self.view.frame.size.height-180, width: 300, height: 60)
        )
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            
        })
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
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(boardList.self, from: dataJSON)
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
    
    // 댓글 리스트 출력
    func CommentListGet(complation : ((Comment_List?) -> ())?){
        let url = "http://test.byeonggook.shop/api/chat/\(DabValue!)/chatList"
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(Comment_List.self, from: dataJSON)
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
    
    // 게시글 삭제
    func commentDelete(complation : ((Comment_List?) -> ())?){
        let url = "test.byeonggook.shop/api/board/\(DabValue)/delete"
        AF.request(url,
                   method: .post,
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(Comment_List.self, from: dataJSON)
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
    
    
    
    // 추천 버튼 클릭
    func GoodButtonClick(value : Int ,commentNum : Int , complation : ((recommend?) -> ())?){
        var url = "http://test.byeonggook.shop/api/board/\(DabValue!)/recommend"
        // value가 1 일때 댓글 추천
        if value == 1{
            url = "http://test.byeonggook.shop/api/chat/\(commentNum)/recommend"
        }
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(recommend.self, from: dataJSON)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("추천 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("추천 에러 : ",error.localizedDescription)
            }
        }
    }
    
    // 비추천 버튼 클릭
    func NotGoodButtonClick(value : Int ,commentNum : Int , complation : ((recommend?) -> ())?){
        var url = "http://test.byeonggook.shop/api/board/\(DabValue!)/deprecate"
        // value가 1 일때 댓글 비추천
        if value == 1{
            url = "http://test.byeonggook.shop/api/chat/\(commentNum)/deprecate"
        }
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(recommend.self, from: dataJSON)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("비추천 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("비추천 에러 : ",error.localizedDescription)
            }
        }
    }
    
    // 신고 버튼 클릭
    func CommentDcButtonClick(value : Int ,commentNum : Int , complation : ((recommend?) -> ())?){
        var url = "http://test.byeonggook.shop/api/board/\(DabValue!)/declaration"
        // value가 1 일때 댓글 비추천
        if value == 1{
            url = "http://test.byeonggook.shop/api/chat/\(commentNum)/declaration"
        }
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(recommend.self, from: dataJSON)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("비추천 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("비추천 에러 : ",error.localizedDescription)
            }
        }
    }
    
    // 전송 버튼 클릭
    func submitButtonClick(nickname : String , password : String , content : String , complation : ((recommend?) -> ())?){
        let url = "http://test.byeonggook.shop/api/chat/\(DabValue!)/chatAdd"
        AF.request(url,
                   method: .post,
                   parameters: ["nickname" : nickname, "password" : password, "content" : content],
                   encoding: URLEncoding.default
        )
            .responseJSON{
                (response) in
            switch response.result{
            case .success(let obj):
                print("GET 성공")
                if obj is NSDictionary{
                    do{
                        //obj를 JSON으로 변경
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        // JSON Decoder 사용
                        let getInstanceData = try JSONDecoder().decode(recommend.self, from: dataJSON)
                        complation!(getInstanceData)
                        
                    }catch{
                        print(obj)
                        print("댓글 달기 에러 : ",error)
                    }
                }
            case.failure(let error):
                print("댓글 달기 에러 : ",error.localizedDescription)
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

extension DetailForumViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    // 바디 뷰 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment.count
    }
    
    // 바디 뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 셀 하나의 너비
        let width: CGFloat = collectionView.frame.size.width
        
        // 셀 하나의 높이
        let height: CGFloat = 140

        return CGSize(width: width, height: height)
    }
    
    // 바디 뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionBody", for: indexPath) as? CommentCollectionViewCell else {
                    return UICollectionViewCell()
                }
        cell.NickName.text = comment[indexPath.row].nickname
        cell.Content.text = comment[indexPath.row].content
        cell.Time.text = comment[indexPath.row].createdDate
        cell.GoodButton.setTitle(String(comment[indexPath.row].recommend ?? 0), for: .normal)
        cell.NotGoodButton.setTitle(String(comment[indexPath.row].deprecate ?? 0), for: .normal)
        
        cell.Content.lineBreakStrategy = .hangulWordPriority
        cell.GoodButton.layer.cornerRadius = 10
        cell.NotGoodButton.layer.cornerRadius = 10
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 15
        cell.layer.backgroundColor = .none
        // 댓글 추천 버튼 클릭 이벤트 추가
        cell.Good = {
            [unowned self] in
            GoodButtonClick(value:1,commentNum: comment[indexPath.row].id! ){
                list in
                if list?.code == 0{
                    CommentListGet(){
                        list in
                        if let list = list{
                            self.comment = []
                            for a in list.result_data.data{
                                self.comment.append(a)
                            }
                            DispatchQueue.main.async {
                                self.Collection.reloadData()
                            }
                            self.showToast(message: "추천에 성공 하셨습니다")
                        }
                    }
                }else{
                    self.showToast(message: list!.error!)
                }
            }
        }
        // 댓글 비추천 버튼 클릭 이벤트 추가
        cell.Bad = {
            [unowned self] in
            NotGoodButtonClick(value:1,commentNum: comment[indexPath.row].id! ){
                list in
                if list?.code == 0{
                    CommentListGet(){
                        list in
                        if let list = list{
                            self.comment = []
                            for a in list.result_data.data{
                                self.comment.append(a)
                            }
                            DispatchQueue.main.async {
                                self.Collection.reloadData()
                            }
                            self.showToast(message: "비추천에 성공 하셨습니다")
                        }
                    }
                }else{
                    self.showToast(message: list!.error!)
                }
            }
        }
        cell.buttonView.delegate = self
        
        cell.buttonView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -5).isActive = true
        cell.buttonView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
        
        cell.buttonView.First = {
            [unowned self] in
            CommentDcButtonClick(value: 1, commentNum: comment[indexPath.row].id!){
                list in
                if list?.code == 0{
                    self.showToast(message: "신고에 성공 하셨습니다")
                }else{
                    self.showToast(message: list!.error!)
                }
            }
        }
        cell.buttonView.Second = {
            [unowned self] in
            self.showToast(message: "수정 눌림 \(comment[indexPath.row].id!)")
        }
        
//        buttonPanelView.delegate = self
//
//        cell.addSubview(buttonPanelView)
//
//        buttonPanelView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
//        buttonPanelView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
//
//        buttonPanelView.First = {
//            [unowned self] in
//
//        }
//        buttonPanelView.Second = {
//            [unowned self] in
//
//        }
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
        
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath) as! BoardHeader
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
            
            headerView.GoodButton.addTarget(self, action: #selector(GoodButton), for: .touchUpInside)
            headerView.NotGoodButton.addTarget(self, action: #selector(NotGoodButton), for: .touchUpInside)

            headerView.etcButtonView.delegate = self
            
            headerView.etcButtonView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
            headerView.etcButtonView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10).isActive = true
            
            headerView.etcButtonView.First = {
                [unowned self] in
                self.DeclarationButtonClick()
            }
            headerView.etcButtonView.Second = {
                [unowned self] in
                self.showToast(message: "수정 눌림 \(comment[indexPath.row].id!)")
            }
            
            return headerView
        }
//        else if kind == UICollectionView.elementKindSectionFooter{
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooter", for: indexPath) as! BoardFooter
//            footerView.layer.borderColor = UIColor.darkGray.cgColor
//            footerView.layer.borderWidth = 1
//            footerView.layer.cornerRadius = 15
//            footerView.backgroundColor = UIColor.white
//
//            footer = footerView
//
//            nickname = footerView.NickName
//            password = footerView.PassWord
//            content = footerView.Content
//            password?.delegate = self
//            nickname?.delegate = self
//            content?.delegate = self
//
//            footerView.Submit.addTarget(self, action: #selector(submitTouch), for: .touchUpInside)
//
//            return footerView
//        }
        
        return UICollectionReusableView()
        
    }
    
}

extension DetailForumViewController : UITextFieldDelegate{
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if keyboardcount == 0{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyhieght = self.view.frame.height
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                view.frame.size.height -= keyboardHeight
                print(keyboardHeight , FooterView.frame.origin.y , self.view.frame.origin.y)
                
            }
            keyboardcount += 1
        }
        
    }
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        print(FooterView.frame.origin.y , self.view.frame.origin.y)
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            view.frame.size.height = keyhieght
            keyboardcount = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func submitTouch(){
        submitButtonClick(nickname: FooterView.NickName.text!, password: FooterView.PassWord.text!, content: FooterView.Content.text!){
            list in
            if list?.code == 0{
                self.ForumTableGet(boardNum: self.DabValue){
                    list in
                    if let list = list {
                        self.Board = list.result_data.account
                        self.CommentListGet(){
                            list in
                            if let list = list{
                                self.comment = []
                                for a in list.result_data.data{
                                    self.comment.append(a)
                                }
                                DispatchQueue.main.async {
//                                    self.setupFlowLayout()
                                    self.Collection.reloadData()
                                }
                                self.showToast(message: "댓글 작성에 성공 하셨습니다")
                            }
                        }
                        
                    }
                    
                }
            }else{
                self.showToast(message: list!.error!)
            }
        }
    }
}


extension DetailForumViewController : ButtonPanelDelegate {
    func didTapButtonWithText(_ text: String) {
        print(text)
    }
}

extension String {
    func heightWithConstrainedWidth(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.height
    }
}
