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

    var cancellables: Set<AnyCancellable> = []

    init(orderBinding: Binding<Order>) {
        self.orderBinding = orderBinding

        // check for cached customer
        if let customer = order.customer {
            self.customer = customer
            return
        }

        // get customers if not already cached
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
            .sink { customer in
                orderBinding.wrappedValue.customer = customer // cache customer
                self.customer = customer
            }
            .store(in: &cancellables)
    }

    // distance in km
    func distanceToCustomer(fromCurrentLocation location: CLLocation?) -> Double? {
        guard let customer = customer else { return nil }
        guard let location = location else { return nil }

        return location.distance(from: CLLocation(latitude: customer.latitude, longitude: customer.longitude)) / 1000.0
    }
}
