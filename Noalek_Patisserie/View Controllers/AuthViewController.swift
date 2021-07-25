//
//  AuthViewController.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import UIKit
import Foundation
import AVFoundation
import AVKit

class AuthViewController: UIViewController {

    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    @IBOutlet weak var registerIcon: UIButton!
    @IBOutlet weak var loginIcon: UIButton!
    
    
    @IBAction func loginBtn(_ sender: Any) {
    }
    
    @IBAction func registerBtn(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpElements()
        setUpVideo()
    }
    
    func setUpElements(){
        Inputs.styleFilledButton(registerIcon)
        Inputs.styleHollowButton(loginIcon)
    }
    
    func setUpVideo(){
        
        //get the pasyh to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "authbg3", ofType: "mp4")
        
        guard bundlePath != nil else{
            return
        }
        
        //create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        //create the video player item
        let item = AVPlayerItem(url: url)
        
        //create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        //notification for loop the video
        NotificationCenter.default.addObserver(self, selector: #selector(self.playItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        
        //create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //adjust the size and frame
        videoPlayerLayer?.frame = view.bounds
        videoPlayerLayer?.videoGravity = .resizeAspectFill
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //add it to the view and play it
        videoPlayer?.playImmediately(atRate: 1)
    }
    
    //loop video
    @objc func playItemDidReachEnd(notification: NSNotification){
        self.videoPlayer?.seek(to: CMTime.zero)
        self.videoPlayer?.playImmediately(atRate: 1)
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
