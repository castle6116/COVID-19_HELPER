//
//  HowToUseViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/04.
//

import UIKit
import AVFoundation

class HowToUseViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    
    var imgName = ["img_coronavirus.png", "img_pie_chart.png", "img_vaccination.png", "img_newspaper.png", "img_board.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        pager.addTarget(self, action: #selector(pageValueDidChanged), for: .valueChanged)
        // 초기화 구현
        pager?.numberOfPages = imgName.count
        // 현재 페이지
        pager?.currentPage = 0
        
        // Do any additional setup after loading the view.
    }
    
    @objc func pageValueDidChanged() {
        let indexPath = IndexPath(row: pager?.currentPage ?? 0, section: 0)
        let animated: Bool = {
            guard #available(iOS 14.0, *) else { return true }
            return pager?.interactionState != .continuous
        }()

        collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
        
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
            
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 220)
            print(layout.itemSize)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            layout.scrollDirection = .horizontal
            return layout
        }()
            
        collectionView.collectionViewLayout = collectionViewLayout
            
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
    }
    
    private func playVideo(with resourceName: String, cell : UIImageView) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.bounds
        cell.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspect
        player.play()
    }

}

extension HowToUseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgName.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UseCell", for: indexPath) as? UseCollection else {
            return UICollectionViewCell()
        }
        cell.CellImage.image = UIImage(named: "\(imgName[indexPath.row])")
        if indexPath.row == 0{
            cell.TitleLabel.text = "안녕하세요!"
            cell.ContentOne.text = "사용자들과 소통이 가능한 게시판과"
            cell.ContentTwo.text = "코로나 19에 대한 다양한 정보를 한곳에서"
            cell.ContentThree.text = "확인할 수 있는 멀티 플랫폼 앱입니다."
            cell.ContentFour.text = ""
            cell.ContentOne.font = UIFont.boldSystemFont(ofSize: 18)
            cell.ContentTwo.font = UIFont.boldSystemFont(ofSize: 18)
            cell.ContentThree.font = UIFont.boldSystemFont(ofSize: 18)
        }else if indexPath.row == 1{
            cell.TitleLabel.text = "상황판"
            cell.ContentOne.text = "일일, 전체 감염 현황과 현 위치 기반"
            cell.ContentTwo.text = "시/도 별 감염 현황을 볼 수 있습니다."
            cell.ContentThree.text = "(위치 기능이 비 활성화 인 경우, 서울로 고정됩니다.)"
            cell.ContentFour.text = ""
            cell.ContentThree.font = UIFont.systemFont(ofSize: 14)
        }else if indexPath.row == 2{
            cell.TitleLabel.text = "백신/진료소"
            cell.ContentOne.text = "접종 현황 및 주변 15km 이내에 있는"
            cell.ContentTwo.text = "코로나19 선별진료소를 리스트 및"
            cell.ContentThree.text = "지도 형태로 볼 수 있습니다."
            cell.ContentFour.text = "(위치 기능이 비 활성화 인 경우, 서울로 고정됩니다.)"
            cell.ContentThree.font = UIFont.boldSystemFont(ofSize: 18)
        }else if indexPath.row == 3{
            cell.TitleLabel.text = "실시간뉴스"
            cell.ContentOne.text = "코로나19에 관련된 최신 뉴스를 표시하며"
            cell.ContentTwo.text = "각 뉴스를 터치하면 브라우저와 링크됩니다."
            cell.ContentThree.text = "(최상단에서 위로 스크롤하면 새로고침됩니다)"
            cell.ContentFour.text = ""
            cell.ContentThree.font = UIFont.systemFont(ofSize: 14)
        }else if indexPath.row == 4{
            cell.TitleLabel.text = "자유게시판"
            cell.ContentOne.text = "코로나19 관련 정보를 나눌 수 있는"
            cell.ContentTwo.text = "자유 게시판이 있습니다."
            cell.ContentThree.text = "최상단에서 위로 스크롤하면 새로고침됩니다."
            cell.ContentFour.text = ""
            cell.ContentThree.font = UIFont.systemFont(ofSize: 14)
        }
//        DispatchQueue.main.async { [weak self] in
//            self?.playVideo(with: "notmy",cell: cell.CellImage)
//        }
        return cell
    }
}

extension HowToUseViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        pager?.currentPage = index
        if index > imgName.count{
            pager?.currentPage = index - 1
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    
}
