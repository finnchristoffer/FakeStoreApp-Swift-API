//
//  Product.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 30/01/23.
//

import Foundation

struct Product: Codable {
    var id: Int?
    let title: String
    let price: Double
    let description: String
    let images: [URL]?
    let category: Category
}
