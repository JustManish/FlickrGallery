//
//  FlickrResponse.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation
import UIKit

struct FlickrResponse: Codable {
    let photos : Photos?
    let stat : String?

    enum CodingKeys: String, CodingKey {

        case photos = "photos"
        case stat = "stat"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decodeIfPresent(Photos.self, forKey: .photos)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
    }
}
