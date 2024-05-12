//
//  VideoPlayerView.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var size: CGSize

    @State private var position: CGFloat = .zero
    @State private var progress: CGFloat = .zero
    @State private var videoProgress: Double = .zero
    @State private var isPlaying: Bool = false
    @State private var timer: Timer?
    
    @StateObject private var soundManager = SoundManager()
    @EnvironmentObject var videoPlayerConfig: VideoPlayerConfig

    let miniPlayerHeight: CGFloat = 50
    let playerHeight: CGFloat = 200
    
    var body: some View {
        if let currentVideo = videoPlayerConfig.currentVideo {
            VStack(spacing: 0) {
//            Capsule()
//                .fill(Color(UIColor.systemGray))
//                .frame(width: isMiniPlayer ? 0 : 60, height: isMiniPlayer ? 0 : 4)
//                .opacity(isMiniPlayer ? 0 : 1)
//                .padding(.top, isMiniPlayer ? 0 : 20)
//                .padding(.bottom, isMiniPlayer ? 0 : 30)
                ZStack(alignment: .top) {
                    GeometryReader {
                        let size = $0.size
                        let width = size.width - 120
                        let height = size.height
                        VideoThumbnailView(currentVideo)
                            .frame(
                                width: 120 + (width - (width * progress)),
                                height: height
                            )
                    }
                    .zIndex(1.0 - (progress * 1.6))
                    
                    PlayerMinifiedContent(currentVideo)
                        .padding(.leading, 130)
                        .padding(.trailing, 15)
                        .foregroundColor(Color.primary)
                        .opacity(progress)
                }
                .frame(minHeight: miniPlayerHeight, maxHeight: playerHeight)
                PlayerExpandContent(currentVideo)
            }
            .background(BlurView())
            .clipShape(.rect(cornerRadius: 10 * (1 - progress)))
            .clipped()
            .contentShape(.rect)
            .offset(y: progress * -tabBarHeight)
            .frame(height: size.height - position, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .gesture(
                DragGesture()
                    .onChanged {value in
                        let start = value.startLocation.y
                        guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlayerHeight)) else { return }
                        
                        let height = value.translation.height
                        position = min(height, (size.height - miniPlayerHeight))
                        generateProgress()
                    }.onEnded { value in
                        let start = value.startLocation.y
                        guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlayerHeight)) else { return }
                        
                        let velocity = value.velocity.height * 5
                        withAnimation(.smooth(duration: 0.3)) {
                            if (position + velocity) > (size.height * 0.65) {
                                position = (size.height - 50)
                                progress = position
                                progress = 1
                            } else {
                                resetPosition()
                            }
                        }
                    }
                    .simultaneously(with: TapGesture().onEnded{ _ in
                        withAnimation(.smooth(duration: 0.3)) {
                            resetPosition()
                        }
                    })
            )
            .transition(.offset(y: progress == 1 ? tabBarHeight : size.height))
            .onReceive(videoPlayerConfig.$currentVideo, perform: { video in
                if video != nil {
                    withAnimation(.smooth(duration: 0.3)) {
                        resetPosition()
                    }
                    initVideoPlayer()
                    playVideoHandler()
                }
            })
        }
    }
    
    // video player view
    @ViewBuilder
    func VideoThumbnailView(_ video: VideoModel) -> some View {
        GeometryReader {
            let size = $0.size
            AsyncImage(url: URL(string: video.thumbnail))
            { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size.width, height: size.width/16 * 9, alignment: .center)
            .clipped()
            .contentShape(.rect)
        }
    }
    
    // mini player content view
    @ViewBuilder
    func PlayerMinifiedContent(_ video: VideoModel) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3, content: {
                Text(video.title)
                    .font(.callout)
                    .textScale(.secondary)
                    .lineLimit(1)
                Text(video.channel)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            })
            .frame(maxHeight: .infinity)
            .frame(maxHeight: miniPlayerHeight)
            
            Spacer(minLength: 0)
            
            Button(action: {playVideoHandler()}, label: {
                if soundManager.audioPlayer?.timeControlStatus == .playing {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                } else {
                    Image(systemName: "play.fill")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                }
            })
            .foregroundColor(.primary)
            .opacity(soundManager.audioPlayer?.status == .readyToPlay ? 1 : 0.5)
            .disabled(soundManager.audioPlayer?.status != .readyToPlay)
            Divider().frame(width: 2).background(Color(UIColor.systemGray3)).padding(.vertical, 5)
            Button(action: {closePlayerHandler()}, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .frame(width: 35, height: 35)
            })
            .foregroundColor(.primary)
        }
    }
    
    // expand player content
    @ViewBuilder
    func PlayerExpandContent(_ video: VideoModel) -> some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text(video.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(video.channel).font(.callout)
            }.frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(formatDate(video.uploadDate))
                    Text(video.description).font(.callout)
                }.padding(10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemGray3))
            .clipShape(.rect(cornerRadius: 10))
            if let chapters = video.chapters {
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(chapters, id: \.startTime) { chapter in
                            chapterContent(chapter).zIndex(2)
                        }
                    }.padding([.leading, .vertical], 15)
                }
                .background(Color(UIColor.systemGray3))
                .clipShape(.rect(cornerRadius: 10))
            }
            playerControl(video)
        }
        .padding(.top, 15)
        .padding(.bottom, tabBarHeight)
        .padding(15)
    }

    // video chapter
    @ViewBuilder
    func chapterContent (_ chapter: Chapter) -> some View {
        Button(action: {
            playerSeekHandler(time: chapter.startTime)
        }, label: {
            VStack(spacing: 0){
                HStack(spacing: 0){
                    Rectangle().fill(Color(UIColor.systemGray)).frame(height: 2)
                    Text("\(formatSeconds(chapter.startTime))")
                        .fixedSize(horizontal: true, vertical: false)
                        .font(.footnote)
                        .padding([.leading, .trailing], 4)
                        .background(.red)
                        .clipShape(.rect(cornerRadius: 5))
                    Rectangle().fill(Color(UIColor.systemGray)).frame(height: 2)
                }
                Text("\(chapter.title)")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .font(.caption)
                    .frame(idealWidth: 80)
                    .padding([.leading, .trailing], 5)
            }
        }).foregroundColor(.primary)
    }
    
    // music player
    @ViewBuilder
    func playerControl (_ video: VideoModel) -> some View {
        VStack(spacing: 0){
            Slider(
                value: $videoProgress,
                in: 1...Double(video.duration),
                step: 1,
                onEditingChanged: {isEditting in
                    let seekTime = CMTimeMakeWithSeconds(Double(videoProgress), preferredTimescale: 1000)
                    if isEditting == true {
                        if isPlaying == true {
                            soundManager.audioPlayer?.pause()
                            updateVideoProgressHandler(false)
                        }
                    } else {
                        soundManager.audioPlayer?.seek(to: seekTime)
                        if isPlaying == true {
                            soundManager.audioPlayer?.play()
                            updateVideoProgressHandler(true)
                        }
                    }
                }
            ).disabled(soundManager.audioPlayer == nil)
                .accentColor(.white)
                .onAppear {
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }
            HStack{
                Text(formatSeconds(Int(videoProgress), true))
                Spacer()
                Text("-\(formatSeconds(video.duration-Int(videoProgress), true))")
            }
            HStack(spacing: 50){
                Button(action: {videoPlayerConfig.previousVideoHandler()}, label: {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fill)
                })
                .foregroundColor(.primary)
                .opacity(videoPlayerConfig.canPlayPrevious ? 1 : 0.5)
                .disabled(!videoPlayerConfig.canPlayPrevious)
                Button(action: {playVideoHandler()}, label: {
                    if soundManager.audioPlayer?.timeControlStatus == .playing {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fill)
                    }
                })
                .foregroundColor(.primary)
                .opacity(soundManager.audioPlayer?.status == .readyToPlay ? 1 : 0.5)
                .disabled(soundManager.audioPlayer?.status != .readyToPlay)
                Button(action: {videoPlayerConfig.nextVideoHandler()}, label: {
                    Image(systemName: "forward.end.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fill)
                })
                .foregroundColor(.primary)
                .opacity(videoPlayerConfig.canPlayNext ? 1 : 0.5)
                .disabled(!videoPlayerConfig.canPlayNext)
            }
        }
    }
    
    func generateProgress() {
        let progress = max(min(position / (size.height - miniPlayerHeight), 1.0), .zero)
        self.progress = progress
    }
    
    func resetPosition() {
        position = .zero
        progress = .zero
    }
    
    func resetPlayer() {
        soundManager.audioPlayer?.pause()
        updateVideoProgressHandler(false)
        videoProgress = .zero
        isPlaying = false
    }
    
    func initVideoPlayer() {
        if let currentVideo = videoPlayerConfig.currentVideo {
            resetPlayer()
            soundManager.setupPlayer(sound: currentVideo.audioUrl)
        }
    }

    func closePlayerHandler() {
        resetPlayer()
        videoPlayerConfig.clearPlayerConfig()
        soundManager.deletePlayer()
    }
    
    func playerSeekHandler(time: Int) {
        let seekTime = CMTimeMakeWithSeconds(Double(time), preferredTimescale: 1000)
        if let audioPlayer = soundManager.audioPlayer {
            if isPlaying == true {
                audioPlayer.pause()
                updateVideoProgressHandler(false)
            }
            audioPlayer.seek(to: seekTime)
            videoProgress = Double(time)
            if isPlaying == true {
                soundManager.audioPlayer?.play()
                updateVideoProgressHandler(true)
            }
        }
    }
    
    func updateVideoProgressHandler(_ isStartUpdate: Bool) {
        if isStartUpdate {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    videoProgress = CMTimeGetSeconds(soundManager.audioPlayer?.currentTime() ?? .zero)
                    if let currentVideo = videoPlayerConfig.currentVideo {
                        if Int(videoProgress) >= currentVideo.duration {
                            videoPlayerConfig.nextVideoHandler()
                            playVideoHandler()
                        }
                    } else {
                        timer?.invalidate()
                    }
                }
            
        } else {
            timer?.invalidate()
        }
    }
    
    func playVideoHandler() {
        if soundManager.audioPlayer?.timeControlStatus == .playing {
            soundManager.audioPlayer?.pause()
            updateVideoProgressHandler(false)
            isPlaying = false
        } else {
            soundManager.audioPlayer?.play()
            updateVideoProgressHandler(true)
            isPlaying = true
        }
    }
}

#Preview {
    let video = VideoModel(    id: "Nci6Oy_rNhY",
                               url: "https://www.youtube.com/watch?v=Nci6Oy_rNhY",
                               title: "Final Fantasy 7 Rebirth Review",
                               thumbnail: "https://i.ytimg.com/vi_webp/Nci6Oy_rNhY/maxresdefault.webp",
                               uploadDate: "20240222",
                               channel: "IGN",
                               channelId: "UCKy1dAqELo0zrOtPkf0eTMw",
                               channelUrl: "https://www.youtube.com/channel/UCKy1dAqELo0zrOtPkf0eTMw",
                               duration: 694,
                               description: "Final Fantasy VII Rebirth reviewed by Michael Higham on PlayStation 5.\n\n\"Final Fantasy VII Rebirth impressively builds off of what Remake set in motion as both a best-in-class action-RPG full of exciting challenge and depth, and as an awe-inspiring recreation of a world that has meant so much to so many for so long. After 82 hours to finish the main story and complete a decent chunk of sidequests and optional activities, there's still much to be done, making this pivotal section of the original feel absolutely massive. Minigames, sidequests, and other enticing diversions fill the spaces of its vast and sprawling regions, painting a new and more vivid picture of these familiar locations. But more than just being filled with things to do, Rebirth is often a powerful representation of Final Fantasy VII's most memorable qualities. It does fumble the execution of its ending, getting caught up in the mess of its multiple twisting timelines, but new moments and the overarching journey manage to evoke a deeper sense of reflection in spite of that. So, for as flawed as parts of how this classic has been reimagined might be, Rebirth still stands out as something both thrilling and unexpectedly impactful.\"",
                               chapters: [
                                Chapter(startTime: 0, title: "Intro", endTime: 73),
                                Chapter(startTime: 73, title: "World Design", endTime: 340),
                                Chapter(startTime: 340, title: "Story", endTime: 605),
                                Chapter(startTime: 605, title: "Conclusion", endTime: 694)
                               ],
                               audioUrl: "",
                               audioFormat: "",
                               videoUrl: "",
                               videoFormat: "",
                               type: "video"
    )
    return GeometryReader { geometry in
        VideoPlayerView(size: geometry.size)
            .environmentObject(VideoPlayerConfig())
    }
}
