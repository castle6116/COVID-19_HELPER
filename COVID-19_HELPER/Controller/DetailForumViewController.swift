//
//  DetailForumViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/16.
//

import UIKit

class DetailForumViewController: UIViewController {
    /// 게시글 ID 넘어오는 값
    var DabValue : Int!
    @IBOutlet weak var Collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Collection.delegate = self
        Collection.dataSource = self
        // Do any additional setup after loading the view.
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionBody", for: indexPath) as? UseCollection else {
                    return UICollectionViewCell()
                }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize { let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 350
        return CGSize(width: width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
        //ofKind에 UICollectionView.elementKindSectionHeader로 헤더를 설정해주고
        //withReuseIdentifier에 헤더뷰 identifier를 넣어주고
        //생성한 헤더뷰로 캐스팅해준다.
        
//        switch kind {
//            case UICollectionView.elementKindSectionHeader:
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath)
//                print("왔다감")
//                return headerView
//            default:
//                assert(false, "응 아니야")
//        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath) as! BoardHeader
        
        headerView.test.text = String(DabValue)
        
        return headerView
    }
    
    
}
