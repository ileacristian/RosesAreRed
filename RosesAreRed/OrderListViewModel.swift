//
//  OrderListViewModel.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import Foundation
import Combine
import Alamofire

@MainActor
class OrderListViewModel: ObservableObject {

    @Published var orders: [Order] = []
    @Published var error: String?

    init() {
        fetchOrders()
        
        error = "Text from alamofire module: \(Alamofire.Request.self)"
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
