//
//  AddFavoriteButtonView.swift
//  YourMusic
//
//  Created by Thanabardi on 12/5/2567 BE.
//

import SwiftUI
import SwiftData

struct AddFavoriteButtonView: View {
    let info: InfoModel
    @State private var parentFolder: FavoriteItem?

    @State private var isShowAddNewFavorite: Bool = false
    @State private var selectedFolder: FavoriteItem?

    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]

    var body: some View {
        VStack {
            if parentFolder != nil {
                Button(action: {removeFavoriteInfo()}, label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .contentShape(.rect)
                })
            } else {
                Button(action: {isShowAddNewFavorite.toggle()}, label: {
                    Image(systemName: "star")
                        .foregroundColor(.primary)
                        .contentShape(.rect)
                })
                .sheet(isPresented: $isShowAddNewFavorite) {
                    VStack {
                        Text("Add New Favorite")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Picker("Folder", selection: $selectedFolder) {
                            Text("Select Folder").tag(nil as FavoriteItem?)
                            ForEach(favoriteItems) {
                                Text($0.title).tag($0 as FavoriteItem?)
                            }
                        }
                        .pickerStyle(.wheel)
                        Spacer()
                        HStack {
                            Button("OK", action: addFavoriteInfo)
                                .opacity(selectedFolder == nil ? 0.5 : 1)
                                .disabled(selectedFolder == nil)
                                .frame(maxWidth: .infinity)
                            Button("Cancle", action: {isShowAddNewFavorite.toggle()})
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 20)
                    .presentationDetents([.medium])
                }
            }
        }
        .onAppear {
            findParentFolder()
        }
    }
    
    func addFavoriteInfo() {
        if info.type == InfoType.video.rawValue {
            if selectedFolder!.videoInfos != nil {
                selectedFolder!.videoInfos!.append(info)
            } else {
                selectedFolder!.videoInfos = [info]
            }
        } else if info.type == InfoType.playlist.rawValue {
            if selectedFolder!.playlistInfos != nil {
                selectedFolder!.playlistInfos!.append(info)
            } else {
                selectedFolder!.playlistInfos = [info]
            }
        }
        parentFolder = selectedFolder
        selectedFolder = nil
    }
    
    func removeFavoriteInfo() {
        if info.type == InfoType.video.rawValue {
            if let index = parentFolder!.videoInfos!.firstIndex(where: {$0.id == info.id}){
                parentFolder!.videoInfos!.remove(at: index)
            }
        } else if info.type == InfoType.playlist.rawValue {
            if let index = parentFolder!.playlistInfos!.firstIndex(where: {$0.id == info.id}){
                parentFolder!.playlistInfos!.remove(at: index)
            }
        }
    }
    
    func findParentFolder() {
        for item in favoriteItems {
            if info.type == InfoType.video.rawValue {
                if let videoinfos = item.videoInfos {
                    for videoInfo in videoinfos {
                        if info.id == videoInfo.id {
                            parentFolder = item
                            return
                        }
                    }
                }
            } else if info.type == InfoType.playlist.rawValue {
                if let playlistInfos = item.playlistInfos {
                    for playlistInfo in playlistInfos {
                        if info.id == playlistInfo.id {
                            parentFolder = item
                            return
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddFavoriteButtonView()
//}
