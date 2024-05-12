//
//  APICallManager.swift
//  YourMusic
//
//  Created by Thanabardi on 5/5/2567 BE.
//

import Foundation

func searchYoutube(query: String, filter: String, start: Int, amount: Int) async throws -> Array<InfoModel> {
    let endpoint = "https://youtube-dlp.vercel.app/api/youtube/search?query=\(query)&filter=\(filter)&playlist_start=\(start)&playlist_amount=\(amount)"
    guard let url = URL(string: endpoint) else {
        throw APIEror.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIEror.invalidResponse
    }
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([InfoModel].self, from: data)
    } catch {
        print(error)
        throw APIEror.invalidData
    }
}

func getVideoDetail(videoId: String, quality: String) async throws -> VideoModel {
    let endpoint = "https://youtube-dlp.vercel.app/api/youtube/info/video?id=\(videoId)&quality=\(quality)"
    guard let url = URL(string: endpoint) else {
        throw APIEror.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIEror.invalidResponse
    }
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(VideoModel.self, from: data)
    } catch {
        print(error)
        throw APIEror.invalidData
    }
}

func getPlaylistDetail(playlistId: String) async throws -> PlaylistModel {
    let endpoint = "https://youtube-dlp.vercel.app/api/youtube/info/playlist?id=\(playlistId)"
    print(endpoint)
    guard let url = URL(string: endpoint) else {
        throw APIEror.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIEror.invalidResponse
    }
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(PlaylistModel.self, from: data)
    } catch {
        print(error)
        throw APIEror.invalidData
    }
}

func getChannelDetail(channelId: String, filter: String, start: Int, amount: Int) async throws -> ChannelModel {
    let endpoint = "https://youtube-dlp.vercel.app/api/youtube/info/channel?id=\(channelId)&filter=\(filter)&playlist_start=\(start)&playlist_amount=\(amount)"
    print(endpoint)
    guard let url = URL(string: endpoint) else {
        throw APIEror.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw APIEror.invalidResponse
    }
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ChannelModel.self, from: data)
    } catch {
        print(error)
        throw APIEror.invalidData
    }
}

enum APIEror: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
