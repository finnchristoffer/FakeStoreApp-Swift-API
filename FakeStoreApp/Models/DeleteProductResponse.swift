//
//  DeleteProductResponse.swift
//  FakeStoreApp
//
//  Created by Finn Christoffer Kurniawan on 31/01/23.
//

import Foundation

struct DeleteProductResponse: Decodable, Encodable {
    var timestamp: String?
    var message: String?
    var name: String?
}
