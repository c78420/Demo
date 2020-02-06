//
//  PlayerPlaybackError.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/12.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation

public enum CTPlayerPlaybackError: Int {
    case unknown
    case notFound
    case unauthorized
    case authenticationError
    case forbidden
    case unavailable
    case mediaFileError
    case bandwidthExceeded
    case playlistUnchanged
    case wrongHostIP
    case wrongHostDNS
    case badURL
    case invalidRequest
}
