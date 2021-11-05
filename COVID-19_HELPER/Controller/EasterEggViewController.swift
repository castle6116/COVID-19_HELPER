//
//  EasterEggViewController.swift
//  COVID-19_HELPER
//
//  Created by 김진우 on 2021/11/05.
//

import UIKit
import AVFoundation

class EasterEggViewController: UIViewController {
    @IBOutlet weak var Easter: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            self?.playVideo(with: "notmy",cell: (self?.Easter)!)
        }
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
