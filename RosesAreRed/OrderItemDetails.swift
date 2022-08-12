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

    @State var errorMessage: String = ""
    @State var showsError = false

    var body: some View {
        VStack(alignment: .leading) {
            headerImageSection

            Group {
                priceSection
                orderStatusSection
                gpsLocationDistanceSection
            }
            .padding(.leading, 20)

            mapSection

            Spacer()
        }
        .navigationTitle(viewModel.order.description)
        .onReceive(viewModel.$error.compactMap{$0}) { errorMessage in // compactMap filters out nil values
            self.errorMessage = errorMessage
            self.showsError = true
        }
        .onReceive(gpsLocationViewModel.$locationError.compactMap{$0}) { errorMessage in
            self.errorMessage = errorMessage
            self.showsError = true
        }
        .alert(errorMessage, isPresented: $showsError, actions: {})
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
                .font(.system(size: 20, weight: .medium))

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
        let text: Text
        if let distanceToCustomer = viewModel.distanceToCustomer(fromCurrentLocation: gpsLocationViewModel.location),
           let customer = viewModel.customer {
            let formattedDistanceString = String(format: "%.1f", distanceToCustomer)
            text = Text("\(customer.name) is \(formattedDistanceString)km away from your current position.")
        } else {
            text = Text("Calculating distance to customer...")
        }
        return text.font(.system(size: 20))
    }

    var mapSection: some View {
        if let currentLocation = gpsLocationViewModel.location, let customer = viewModel.customer {
            return AnyView(
                MapView(startLocation: currentLocation.coordinate, endLocation: customer.coordinate)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding()
            )
        } else {
            return AnyView(EmptyView())

        }
    }
}

struct OrderItemDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let order = Order(id: 1,
                              description: "Tulips",
                              price: 69,
                              customer_id: 143,
                              image_url: "https://cdn.britannica.com/37/227037-050-CA792866/Broken-tulip-flower.jpg",
                              status: .new)
            
            OrderItemDetails(viewModel: OrderItemDetailsViewModel(orderBinding: .constant(order)))
            .navigationTitle("Tulips")
        }
    }
}
