//
//  AddFolderButtonView.swift
//  YourMusic
//
//  Created by Thanabardi on 12/5/2567 BE.
//

import SwiftUI
import SwiftData

struct AddFolderButtonView: View {
    let parent: FavoriteItem
    var delegate: UpdateFavoriteItemDelegate?

    @State private var newFolderName: String = ""
    @State private var isShowAddNewFolder: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteItems: [FavoriteItem]
    
    var body: some View {
        Button(action: {isShowAddNewFolder.toggle()}, label: {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 20)
                .bold()
                .contentShape(.rect)
                .foregroundStyle(.white)
                .padding(15)
        })
        .background(.red)
        .clipShape(.circle)
        .alert("New Folder", isPresented: $isShowAddNewFolder) {
            TextField("Folder name", text: $newFolderName)
            Button("OK", action: addFolder)
                .disabled(newFolderName == "")
            Button("Cancle", action: {isShowAddNewFolder.toggle()})
        }
    }
    
    func addFolder() {
        withAnimation {
            let newFolder = FavoriteItem(title: newFolderName, parent: parent)
            modelContext.insert(newFolder)
            newFolderName = ""
            delegate?.updateFavoriteItem()
        }
    }
}

//#Preview {
//    AddFolderButtonView()
//}
