//
//  AnvatoData.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/26.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

struct AnvatoData: Decodable {
    var docs: [VideoInfo]?
}

struct VideoInfo: Decodable {
    var obj_type: String?
    var obj_id: String?
    var c_title_s: String?
    var c_description_s: String?
    var media_url: String?
    var thumbnails: [Thumbnails]?
}

struct Thumbnails: Decodable {
    var url: String?
}
