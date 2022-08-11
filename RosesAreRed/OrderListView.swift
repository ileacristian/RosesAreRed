//
//  OrderListView.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI

struct OrderListView: View {
    @StateObject var viewModel = OrderListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.orders) { order in
                    OrderItemRowView(order: order)
                }

                if viewModel.orders.isEmpty {
                    emptyView
                }
            }
            .refreshable {
                viewModel.fetchOrders()
            }
            .navigationTitle("Orders")
        }
    }

    var emptyView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
