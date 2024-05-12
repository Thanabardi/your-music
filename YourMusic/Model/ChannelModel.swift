//
//  ChannelModel.swift
//  YourMusic
//
//  Created by Thanabardi on 5/5/2567 BE.
//

import Foundation

struct ChannelModel: Codable, Equatable {
    let id: String
    let banner: String?
    let avatar: String?
    let channel: String
    let channelId: String?
    let channelUrl: String?
    let followers: Int?
    let type: String
    var playlist: Array<InfoModel> = []
}
