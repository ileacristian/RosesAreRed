//
//  OrderStatusView.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 11/08/2022.
//

import SwiftUI

struct OrderStatusView: View {
    @State var status: OrderStatus
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .frame(minWidth: 50)
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.backgroundColor)
            }
    }

    var backgroundColor: Color {
        switch status {
        case .new:
                return .green.opacity(0.9)
        case .pending:
                return .orange.opacity(0.9)
        case .delivered:
                return .blue.opacity(0.9)
        }
    }
}

struct OrderStatusView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(OrderStatus.allCases) { orderStatusType in
                HStack {
                    Text("My text")
                    OrderStatusView(status: orderStatusType)
                }
            }
        }
    }
}
