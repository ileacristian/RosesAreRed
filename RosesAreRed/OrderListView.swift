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
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
