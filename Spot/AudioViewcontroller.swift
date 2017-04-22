//
//  AudioViewcontroller.swift
//  Spot
//
//  Created by Unlocked on 4/21/17.
//  Copyright © 2017 Unlocked. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    var mainPreviewURL = String()
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
        downloadFileFromURL(url: URL(string: mainPreviewURL)!)
        playPauseButton.setTitle("Pause", for: .normal)
        
    }
    
    func downloadFileFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url
            , completionHandler: { (customURL, response, error) in
                self.play(url: customURL!)
        })
        
        downloadTask.resume()
    }
    
    func play(url : URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        }else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
}
