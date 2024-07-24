//
//  UnsplashModel.swift
//  ProductHuntFetch
//
//  Created by Space Wizard on 7/23/24.
//

import Foundation

struct UnsplashModel: Decodable {
    let tagline: String?
    let bio: String?
    let urls: URLModel?
}

struct URLModel: Decodable {
    let full: String?
}
