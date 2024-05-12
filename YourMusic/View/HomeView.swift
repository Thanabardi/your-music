//
//  HomeView.swift
//  YourMusic
//
//  Created by Thanabardi on 4/5/2567 BE.
//

import SwiftUI

struct HomeView: View {
    @State private var currentTab: Tab = .favorite
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                FavoriteView()
                    .setupTab(.favorite)
                SearchView()
                    .setupTab(.search)
            }
            .padding(.bottom, tabBarHeight)
            
            // VideoPlayerView
            GeometryReader {
                let size = $0.size
                VideoPlayerView(size: size)
            }
            
            CustomTabBar()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.title2)
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(currentTab == tab ? Color.red : .gray)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .contentShape(.rect)
                .onTapGesture {
                    currentTab = tab
                }.padding(.top, 15)
            }
        }
        .frame(height: 50)
        .overlay(alignment: .top) {
            Divider().background(Color(UIColor.systemGray5))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: tabBarHeight)
        .background(Color(UIColor.systemGray6))
    }
}

extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat {
        return 50 + safeArea.bottom
    }
}

#Preview {
    HomeView()
        .environmentObject(VideoPlayerConfig())
}
