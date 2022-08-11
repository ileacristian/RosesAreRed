//
//  OrderItemDetails.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI
struct OrderItemDetails: View {
    @Binding var order: Order
    var body: some View {
        VStack(alignment: .leading) {
            headerImage

            Group {
                priceRow
                orderStatusRow
            }
            .padding(.leading, 20)

            Spacer()
        }
        .navigationTitle(order.description)
    }

    var headerImage: some View {
        AsyncImage(url: URL(string: order.image_url)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(height: 200)
        .clipped()
    }

    var priceRow: some View {
        Text("Price: \(order.price)$")
            .font(.system(size: 25, weight: .bold))
            .padding(.top, 20)
    }

    var orderStatusRow: some View {
        HStack {
            Text("Order status:")
                .font(.system(size: 18, weight: .medium))

            OrderStatusView(status: order.status)

            Menu {
                Picker("Order status", selection: $order.status) {
                    ForEach(OrderStatus.allCases) { orderStatus in
                        Text(orderStatus.rawValue)
                    }
                }
            } label: {
                Text("Edit")
            }
        }
    }
}

struct OrderItemDetails_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderItemDetails(order: .constant(Order(id: 1,
                                                    description: "Tulips",
                                                    price: 69,
                                                    customer_id: 143,
                                                    image_url: "https://cdn.britannica.com/37/227037-050-CA792866/Broken-tulip-flower.jpg",
                                                    status: .new)))
                .navigationTitle("Tulips")
        }
    }
}
