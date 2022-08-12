//
//  MapView.swift
//  RosesAreRed
//
//  Created by Cristian Ilea on 12/08/2022.
//

import SwiftUI
import MapKit
import Contacts

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    let startLocation: CLLocationCoordinate2D
    let endLocation: CLLocationCoordinate2D

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: [CNPostalAddressCountryKey: "You"])
        let endPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: [CNPostalAddressCountryKey: "Destination"])

        let request = MKDirections.Request()
        let source = MKMapItem(placemark: startPlacemark)
        let destination = MKMapItem(placemark: endPlacemark)

        request.source = source
        request.destination = destination
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([startPlacemark, endPlacemark])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35),
                animated: true)
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(startLocation: CLLocationCoordinate2D(latitude: 40.71, longitude: -74),
                endLocation: CLLocationCoordinate2D(latitude: 42.36, longitude: -71.05))
    }
}
