//
//  OrderListViewModel.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import Combine

@MainActor
class OrderListViewModel: ObservableObject {

    @Published var orders: [Order] = []
    @Published var error: String = ""

    var cancellables: Set<AnyCancellable> = []

    init() {
        fetchOrders()
    }

    func fetchOrders() {
        orders = []
        API.shared.getOrders()
            .catch { error -> Just<[Order]> in
                self.error = error.prettyErrorMessage()
                return Just([])
            }
            .assign(to: &$orders)
    }

    
}
