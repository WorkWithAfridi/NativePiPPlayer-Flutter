//
//  SwiftUIView.swift
//  Runner
//
//  Created by Khondakar Afridi on 3/3/24.
//

import SwiftUI

struct SwiftUIView: View {
    @StateObject var playerController = PlayerController()
    
    var body: some View {
        VStack(alignment: .center){
            Text("This is done in SwiftUI")
                .padding(.bottom, 10)
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
            
            Button {
                playerController.playPlayer()
            } label: {
                Text("Play video")
            }
            .padding(.bottom, 10)
            
            Button {
                playerController.pausePlayer()
            } label: {
                Text("Pause video")
            }
            
            
        }
        .onAppear {
            playerController.initPlayer(title: "SomeTitle", link: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", artist: "Khondakar Afridi", artwork: "Artist")
        }
    }
}

#Preview {
    SwiftUIView()
}
