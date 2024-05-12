//
//  Utility.swift
//  YourMusic
//
//  Created by Thanabardi on 7/5/2567 BE.
//

import Foundation

func formatSeconds(_ seconds: Int, _ isFull: Bool? = nil) -> String {
    let hour = seconds / 3600
    let minute = seconds / 60 % 60
    let second = seconds % 60

    if (isFull != nil && isFull == true) || hour > 0 {
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    } else if minute > 0 {
        return String(format: "%02i:%02i", minute, second)
    } else if second == 0 {
        return "00:00"
    } else {
        return String(format: "00:%02i", second)
    }
}

func formatDate(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyymmdd"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "d MMM yyyy"
    let resultString = dateFormatter.string(from: date!)
    return resultString
}

func formatFollower(_ follower: Int) -> String {
    let number = Double(follower)
    let billion = number / 1_000_000_000
    let million = number / 1_000_000
    let thousand = number / 1000
    
    if billion >= 1 {
        return "\(billion.formatted(.number.precision(.fractionLength(0...2))))B"
    } else if million >= 1 {
        return "\(million.formatted(.number.precision(.fractionLength(0...2))))M"
    } else if thousand >= 1 {
        return "\(thousand.formatted(.number.precision(.fractionLength(0...2))))K"
    } else {
        return "\(follower)"
    }
}
