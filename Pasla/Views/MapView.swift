//
//  MapView.swift
//  Pasla
//
//  Created by Anıl Demirci on 10.02.2022.
//

import SwiftUI
import MapKit
import Firebase

struct MapView: View {
    @StateObject private var mapViewModel=MapViewModel()
    @State var nameStadium=""
    @State var town=""
    @State var city=""
    @State var chosenLatitude=""
    @State var chosenLongitude=""
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region,showsUserLocation: true)
            .onAppear{
                mapViewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}







