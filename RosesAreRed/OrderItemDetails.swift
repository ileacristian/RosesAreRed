//
//  OrderItemDetails.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct OrderItemDetails: View {
    @ObservedObject var viewModel: OrderItemDetailsViewModel
    @StateObject var gpsLocationViewModel = GPSLocationViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            headerImageSection

            Group {
                priceSection
                orderStatusSection
                gpsLocationDistanceSection
            }
            .padding(.leading, 20)

            Spacer()
        }
        .navigationTitle(viewModel.order.description)
    }

    var headerImageSection: some View {
        CachedAsyncImage(url: URL(string: viewModel.order.image_url)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .frame(height: 200)
        .clipped()
    }

    var priceSection: some View {
        Text("Price: \(viewModel.order.price)$")
            .font(.system(size: 25, weight: .bold))
            .padding(.top, 20)
    }

    var orderStatusSection: some View {
        HStack {
            Text("Order status:")
                .font(.system(size: 18, weight: .medium))

            OrderStatusView(status: viewModel.order.status)

            Menu {
                Picker("Order status", selection: viewModel.orderBinding.status) {
                    ForEach(OrderStatus.allCases) { orderStatus in
                        Text(orderStatus.rawValue)
                    }
                }
            } label: {
                Text("Edit")
            }
        }
    }

    var gpsLocationDistanceSection: some View {
        if let distanceToCustomer = viewModel.distanceToCustomer(fromCurrentLocation: gpsLocationViewModel.location) {
            let formattedDistanceString = String(format: "%.1f", distanceToCustomer)
            return Text("The customer is \(formattedDistanceString)km away from your current position.")
        } else {
            return Text("Calculating distance to customer...")
        }
    }
}

struct OrderItemDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderItemDetails(viewModel: OrderItemDetailsViewModel(orderBinding: .constant(Order(id: 1,
                                                                                                description: "Tulips",
                                                                                                price: 69,
                                                                                                customer_id: 143,
                                                                                                image_url: "https://cdn.britannica.com/37/227037-050-CA792866/Broken-tulip-flower.jpg",
                                                                                                status: .new))))
            .navigationTitle("Tulips")
        }
    }
}
