//
//  PinView.swift
//  Pasla
//
//  Created by Anıl Demirci on 11.02.2022.
//

import SwiftUI
import MapKit
import Firebase

struct PinView: View {
    
    var body: some View {
        VStack {
            
            MappView()
            
            Button(action: {
                var firestoreDatabase=Firestore.firestore()
                var currentUser=Auth.auth().currentUser
                var nameStadium=""
                var town=""
                var city=""
                var chosenLatitude=Double()
                var chosenLongitude=Double()
                
                let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser!.email!,
                                   "StadiumName":nameStadium,
                                   "Town":town,
                                   "City":city,
                                   "Latitude":chosenLatitude,
                                   "Longitude":chosenLongitude,
                                   "AnnotationTitle":nameStadium,
                                   "Date":FieldValue.serverTimestamp()] as [String:Any]
                
                firestoreDatabase.collection("Locations").document(currentUser!.uid).setData(firestoreUser) {
                        error in
                        if error != nil {
                            //self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                        } else {
                            //self.makeAlert(titleInput: "Başarılı", messageInput: "Konumunuz eklendi.")
                        }
                    }
            }) {
                Text("kaydet")
            }
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


