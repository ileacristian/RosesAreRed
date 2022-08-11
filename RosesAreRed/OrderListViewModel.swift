//
//  OrderListViewModel.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import Combine

class OrderListViewModel: ObservableObject {

    var cancellables: Set<AnyCancellable> = []

    init() {
        API.shared.getOrders()
            .sink { completion in
                print(completion)
            } receiveValue: { orders in
                print(orders)
            }
            .store(in: &cancellables)

        API.shared.getCustomers()
            .sink { completion in
                print(completion)
            } receiveValue: { customers in
                print(customers)
            }
            .store(in: &cancellables)
    }
}
