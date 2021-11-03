//
//  Photos.swift
//  FlickrGallery
//
//  Created by Manish Patidar on 03/11/21.
//

import Foundation
import UIKit

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [Photo]
    let total: Int
    
    /*enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case photo
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        perpage = try container.decode(Int.self, forKey: .perpage)
        photo = try container.decode([FlickrPhoto].self, forKey: .photo)
        total = try container.decode(String.self, forKey: .total)
    }*/
}
