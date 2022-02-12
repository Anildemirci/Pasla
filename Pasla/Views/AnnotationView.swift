//
//  AnnotationView.swift
//  Pasla
//
//  Created by Anıl Demirci on 10.02.2022.
//

import SwiftUI
import MapKit
import Firebase

struct AnnotationView: View {
    
    @State private var showingPlaceDetails=false
    @StateObject private var mapViewModel=MapViewModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var body: some View {
        ZStack{
            MapView()
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
            .alert(isPresented: $showingPlaceDetails) {
                Alert(title: Text("hata"), message: Text("bilinmiyor"), primaryButton: .default(Text("ok")), secondaryButton: .default(Text("edit")){
                    
                })
            }
        }
    }
    
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView()
    }
}






