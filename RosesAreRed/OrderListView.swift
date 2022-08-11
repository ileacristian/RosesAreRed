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
            ZStack {
                List {
                    ForEach($viewModel.orders) { order in
                        NavigationLink(destination: OrderItemDetails(viewModel: OrderItemDetailsViewModel(orderBinding: order))) {
                            OrderItemRowView(order: order)
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchOrders()
                }
                .navigationTitle("Orders")

                if viewModel.orders.isEmpty {
                    emptyView
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
