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
                GeometryReader { geometry in
                    let parentWidth = geometry.size.width
                    
                    if playerController.player == nil {
                        Text("Loading")
                    } else {
                        VideoPlayer(playerController: playerController)
                            .frame(width: parentWidth)
                    }
                }
                .frame(height: 200)
                .padding(.bottom, 10)
            } else {
                
            }
        }
        .onAppear {
            playerController.initPlayer(title: "SomeTitle", link: link ??  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", artist: "Khondakar Afridi", artwork: "Artist", duration: duration, playbackMode: mode ?? "pip")
        }
    }
}

#Preview {
    SwiftUIView()
}
