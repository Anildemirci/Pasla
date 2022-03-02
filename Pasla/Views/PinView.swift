//
//  PinView.swift
//  Pasla
//
//  Created by Anıl Demirci on 11.02.2022.
//

import SwiftUI
import MapKit
import Firebase

//pini işaretlediğin yerin koordinatları, posta kodu, bölge adı gibi bilgilerini veriyor.
//henüz bir yerde kullanılmıyor.

struct PinView: View {
    
    var body: some View {
        VStack {
            MapView()
        }
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView()
    }
}

struct MappView : UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return MappView.Coordinator(parent1: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        let coordinate=CLLocationCoordinate2D(latitude: 41.0330382, longitude: 28.4517462)
        map.region=MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let annotation=MKPointAnnotation()
        annotation.coordinate=coordinate
        map.delegate=context.coordinator
        map.addAnnotation(annotation)
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject,MKMapViewDelegate {
        var parent:MappView
        
        init(parent1:MappView) {
            parent=parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable=true
            pin.pinTintColor = .red
            pin.animatesDrop = true
            
            return pin
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { (places, error)  in
                print((places?.first?.name)!)
                print((places?.first?.locality)!)
                print(view.annotation?.coordinate.latitude)
                print(view.annotation?.coordinate.longitude)
            }
        }
    }
}


