//
//  OrderListView.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI

struct OrderListView: View {
    @StateObject var viewModel = OrderListViewModel()
    @State var errorMessage: String = ""
    @State var showsError = false
    
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
        .onReceive(viewModel.$error.compactMap{$0}) { errorMessage in  // compactMap filters out nil values
            self.errorMessage = errorMessage
            self.showsError = true
        }
        .alert(errorMessage, isPresented: $showsError, actions: {})
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
