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

class UseCollection: UICollectionViewCell{
    @IBOutlet weak var CellImage: UIImageView!
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
