//
//  WriteViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/29.
//

import UIKit
import Alamofire

class WriteViewController: UIViewController {
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputNickName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var inputContent: UITextView!
    @IBOutlet weak var contentCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "글쓰기",
            style: UIBarButtonItem.Style.plain,
            target: self, action: #selector(forumWrite))
    }
    
    func startUI(){
        inputContent.delegate = self
        inputContent.layer.borderColor = CGColor(red: 0.921, green: 0.922, blue: 0.921, alpha: 1.0)
        inputContent.layer.borderWidth = 1
        inputContent.layer.cornerRadius = 10
        userPassword.isSecureTextEntry = true
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
    
    @objc func forumWrite(){
        let url = "http://test.byeonggook.shop/api/board/boardAdd"
        if inputTitle.text!.count < 2{
            showToast(message: "제목을 입력 해 주세요")
        }else if inputNickName.text!.count < 2{
            showToast(message: "닉네임을 입력 해 주세요")
        }else if userPassword.text!.count < 2{
            showToast(message: "비밀번호를 입력 해 주세요")
        }else if inputContent.text!.count < 2{
            showToast(message: "내용을 입력 해 주세요")
        }else{
            AF.request(url,
                method: .post,
                parameters: ["nickname" : inputNickName.text! , "password" : userPassword.text! , "title" : inputTitle.text! , "content" : inputContent.text!],
                           encoding: URLEncoding.default
            )
            .responseJSON{
                (response) in
                switch response.result{
                case .success(let obj):
                    print("글쓰기 성공")
                    if obj is NSDictionary{
                        do{
                            //obj를 JSON으로 변경
                            let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            // JSON Decoder 사용
                            let getInstanceData = try JSONDecoder().decode(recommend.self, from: dataJSON)
                            print(getInstanceData)
                            self.navigationController?.popViewController(animated: true)
                        }catch{
                            print(obj)
                            print("글쓰기 에러 : ",error)
                        }
                    }
                case.failure(let error):
                    print("글쓰기 에러 : ",error.localizedDescription)
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

}

extension WriteViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = 250 + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount { //11글자
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: String.IndexDistance(-overflow))
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
                
            textView.replace(textRange, withText: String(newText))
            
            return false
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 250 {
        //글자수 제한에 걸리면 마지막 글자를 삭제함.
            textView.text.removeLast()
            contentCount.text = "\(textView.text.count)/250"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {return }
        
        contentCount.text = "\(textView.text.count)/250"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
