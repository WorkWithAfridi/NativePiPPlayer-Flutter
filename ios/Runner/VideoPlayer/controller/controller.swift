//
//  PlayerController.swift
//  Pip Player
//
//  Created by Khondakar Afridi on 3/3/24.
//

import Foundation
import AVKit
import AVFoundation

class PlayerController: ObservableObject{
    @Published var playbackVideoLink: String = ""
    @Published var playbackTitle: String = ""
    @Published var playbackArtist: String = ""
    @Published var playbackArtwork: String = ""
    var duration: TimeInterval?
    @Published var mode: String = ""
    
    var alreadySeekedToDuration = false
    @Published var isLoading = true
    
    
    var player: AVPlayer?
    var avPlayerViewController: AVPlayerViewController = AVPlayerViewController()
    
    func initPlayer(
        title: String,
        link: String,
        artist: String,
        artwork: String,
        duration: TimeInterval?,
        playbackMode: String){
            self.playbackTitle = title
            self.playbackArtist = artist
            self.playbackArtwork = artwork
            self.playbackVideoLink = link
            self.duration = duration
            self.mode = playbackMode
            
            setupPlayer()
            setupAVPlayerViewController()
        }
    
    private func setupPlayer(){
        player = AVPlayer(url: URL(string: playbackVideoLink)!)
        
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            if (self?.player?.rate ?? -1) > 0.0 {
                if self?.alreadySeekedToDuration == false {
                    self?.isLoading = false
                    self?.alreadySeekedToDuration = true
                    self?.seekToDuration()
                }
            }
        }
        
        let title = AVMutableMetadataItem()
        title.identifier = .commonIdentifierTitle
        title.value = "Some random title" as NSString
        title.extendedLanguageTag = "und"
        
        let artist = AVMutableMetadataItem()
        artist.identifier = .commonIdentifierArtist
        artist.value = "Khondakar Afridi" as NSString
        artist.extendedLanguageTag = "und"
        
        let artwork = AVMutableMetadataItem()
        if let image = UIImage(named: "Artist") {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                artwork.identifier = .commonIdentifierArtwork
                artwork.value = imageData as NSData
                artwork.dataType = kCMMetadataBaseDataType_JPEG as String
                artwork.extendedLanguageTag = "und"
            }
        }
        
        player?.currentItem?.externalMetadata = [title, artist, artwork]
    }
    
    private func setupAVPlayerViewController(){
        avPlayerViewController.player = player
        avPlayerViewController.allowsPictureInPicturePlayback = true
        avPlayerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        playPlayer()
    }
    
    func pausePlayer(){
        player?.pause()
    }
    
    func playPlayer(){
        player?.play()
    }
    
    
    func seekToDuration(){
        if duration != nil {
            player?.seek(to:  CMTime(seconds: duration!, preferredTimescale: 1000))
        } else {
            print("Duration is nil");
        }
    }
}
