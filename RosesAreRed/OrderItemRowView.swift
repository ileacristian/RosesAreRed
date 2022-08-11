//
//  OrderItemRowView.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI
import CachedAsyncImage

struct OrderItemRowView: View {
    @Binding var order: Order
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: order.image_url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            .padding(5)
            Text(order.description)
            Spacer()
            OrderStatusView(status: order.status)
        }
    }
}

struct OrderItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OrderItemRowView(order: .constant(Order(id: 1,
                                                    description: "Test",
                                                    price: 5,
                                                    customer_id: 1,
                                                    image_url: "https://images.pexels.com/photos/736230/pexels-photo-736230.jpeg",
                                                    status: .new)))
        }
    }
}
