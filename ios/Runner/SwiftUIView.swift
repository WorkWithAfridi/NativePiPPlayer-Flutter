//
//  SwiftUIView.swift
//  Runner
//
//  Created by Khondakar Afridi on 3/3/24.
//

import SwiftUI

struct SwiftUIView: View {
    @StateObject var playerController = PlayerController()
    
    var link: String?
    var duration: TimeInterval?
    var mode: String?
    
    
    var body: some View {
        VStack(alignment: .center){
            if playerController.mode == "pip" {
                VStack{
                    if playerController.player == nil {
                        Text("Loading")
                    } else {
                        VideoPlayer(playerController: playerController)
                            .padding(.bottom, 10)
                    }
                    if playerController.isLoading {
                        HStack{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding(.trailing, 10)
                            Text("Please wait for the video to load, before continuing.")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    } else {
                        HStack{
                            Image(systemName: "checkmark")
                                .padding(.trailing, 10)
                            Text("Video loaded, you can now continue in Picture-in-picture mode.")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                
            }
        }
        .onAppear {
            if mode == "pip" {
                playerController.initPlayer(title: "SomeTitle", link: link ??  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", artist: "Khondakar Afridi", artwork: "Artist", duration: duration, playbackMode: mode ?? "pip")
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
