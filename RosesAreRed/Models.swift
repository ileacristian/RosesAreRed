//
//  Models.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import CoreLocation

enum OrderStatus: String, Codable {
    case new
    case pending
    case delivered
}

struct Order: Codable {
    let id: Int
    let description: String
    let price: Int
    let customer_id: Int
    let image_url: String
    let status: OrderStatus
}

struct Customer: Codable {
    let id: Int
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
