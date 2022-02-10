//
//  MapViewModel.swift
//  Pasla
//
//  Created by Anıl Demirci on 10.02.2022.
//

import MapKit

enum MapDetails {
    static let startingLocation=CLLocationCoordinate2D(latitude: 41.0330382, longitude: 28.9603956)
    static let defaultSpan=MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
}

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var region=MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager=CLLocationManager()
            locationManager!.delegate=self
            
        } else {
            //alert göster konuma izin vermesi gerektiğini
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("konumuz kısıtlanmıştır(ebeveyn denetimleri gibi)")
        case .denied:
            print("Konumuza izin verilmedi ayarlardan düzeltin.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
