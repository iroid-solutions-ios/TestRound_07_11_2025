//
//  Service.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//


import SwiftUI

struct Service: Identifiable, Codable {
    var id: Int
    var name: String
    var img: String
    
    static let demo: [Service] = [
        Service(id: 1, name: "Netflix", img: "netflix_icon"),
        Service(id: 2, name: "Hulu", img: "hulu_icon"),
        Service(id: 3, name: "Spotify", img: "spotify_icon"),
        Service(id: 4, name: "PlayStation+", img: "play_station_icon"),
        Service(id: 5, name: "Paramount+", img: "paramount_icon"),
        Service(id: 6, name: "YouTube Music", img: "youtube_music_icon")
    ]
}
