//
//  YourMusicApp.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import SwiftUI
import SwiftData

@main
struct YourMusicApp: App {
    @StateObject var videoPlayerConfig = VideoPlayerConfig()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(videoPlayerConfig)
        }
        .modelContainer(sharedModelContainer)
    }
}
