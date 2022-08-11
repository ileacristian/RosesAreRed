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
    @Published var error: String?

    var cancellables: Set<AnyCancellable> = []

    init() {
        fetchOrders()
    }

    func fetchOrders() {
        API.shared.getOrders()
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main) // delay just for fun
            .catch { error -> Just<[Order]> in
                self.error = error.prettyErrorMessage()
                return Just([])
            }
            .assign(to: &$orders)
    }
}
