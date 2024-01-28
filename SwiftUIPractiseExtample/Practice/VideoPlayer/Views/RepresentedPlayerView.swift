//
//  RepresentedPlayerView.swift
//  SwiftUIPractiseExtample
//
//  Created by Yumin Chu on 1/21/24.
//

import SwiftUI
import AVKit
import Combine

struct RepresentedPlayerView: UIViewRepresentable {
  @Binding var videoName: String
  private let videoPlayer = VideoPlayerView()
  
  func makeUIView(context: Context) -> VideoPlayerView {
    videoPlayer.playVideo(videoName: videoName)
    return videoPlayer
  }
  
  func updateUIView(_ uiView: VideoPlayerView, context: Context) {
    guard videoName != uiView.videoName else { return }
    videoPlayer.playVideo(videoName: videoName)
  }
}

final class VideoPlayerView: UIView {
  private var player = AVPlayer()
  private var playerLayer = AVPlayerLayer()
  private var cancelBag = Set<AnyCancellable>()
  @Published var videoName: String?

  override init(frame: CGRect) {
    super.init(frame: .zero)
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
    self.playerLayer = AVPlayerLayer(player: player)
    layer.addSublayer(playerLayer)
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Do not use Storyboard.")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
  }
  
  private func bind() {
    $videoName
      .receive(on: DispatchQueue.main)
      .sink { [weak self] name in
        guard let path = Bundle.main.path(forResource: name, ofType: "mp4") else {
          print("Video Not Found.")
          return
        }
        
        self?.player.replaceCurrentItem(with: AVPlayerItem(url: URL(filePath: path)))
        self?.player.play()
        print("play")
      }
      .store(in: &cancelBag)
  }
  
  func playVideo(videoName: String) {
    self.videoName = videoName
  }
}
