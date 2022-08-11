//
//  OrderItemDetailsViewModel.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

@MainActor
class OrderItemDetailsViewModel: ObservableObject {
    var orderBinding: Binding<Order>
    var order: Order {
        orderBinding.wrappedValue
    }

    @Published var customer: Customer?
    @Published var error: String?

    init(orderBinding: Binding<Order>) {
        self.orderBinding = orderBinding

        API.shared.getCustomers()
            .catch { error -> Just<[Customer]> in
                self.error = error.prettyErrorMessage()
                return Just([])
            }
            .map { allCustomers in
                allCustomers.first { customer in
                    customer.id == self.order.customer_id
                }
            }
            .assign(to: &$customer)
    }

    // distance in km
    func distanceToCustomer(fromCurrentLocation location: CLLocation?) -> Double? {
        guard let customer = customer else { return nil }
        guard let location = location else { return nil }

        return location.distance(from: CLLocation(latitude: customer.latitude, longitude: customer.longitude)) / 1000.0
    }
}
