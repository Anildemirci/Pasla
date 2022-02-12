//
//  LaunchScreenView.swift
//  Pasla
//
//  Created by Anıl Demirci on 12.02.2022.
//

import SwiftUI
import Firebase

struct LaunchScreenView: View {
    
    @State private var showMainView=false
    @State private var angle: Double = 360
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    @State var screen=""
    var currentUser=Auth.auth().currentUser
    var firebaseDatabase=Firestore.firestore()
    
    var body: some View {
        VStack{
            if showMainView == true {
                if screen=="userProfile" {
                    UserAccountView()
                } else if screen=="userBirthDate" {
                    UserBirthday()
                } else if screen=="userAddress" {
                    UserLocation()
                } else if screen=="userPhone" {
                    UserPhoneNumber()
                } else if screen=="userInfo" {
                    UserInfoView()
                } else if screen=="stadiumProfile" {
                    StadiumAccountView()
                } else if screen=="stadiumInfo" {
                    StadiumInfoView()
                } else if screen=="stadiumAddress"{
                    StadiumLocation()
                } else if screen=="stadiumPhone" {
                    StadiumPhoneNumber()
                } else {
                    HomeView()
                }
            } else {
                Image("paslaLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1)
                    .rotation3DEffect(.degrees(angle), axis: (x:0.0, y:1.0, z:0.0))
                    .opacity(opacity)
                    .scaleEffect(scale)
            }
        }.onAppear{
            withAnimation(.linear(duration: 2)){
                angle=0
                scale=3
                opacity=0
            }
            withAnimation(Animation.linear.delay(1.5)){
                showMainView=true
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                getData()
            }
        }
    }
    
    func getData(){
        
        var userTypeArray=[String]()
        var stadiumTypeArray=[String]()
        
        if currentUser != nil {
            firebaseDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        if let userType=document.get("User") as? String{
                            userTypeArray.append(userType)
                            if userTypeArray.contains(currentUser!.uid) {
                                firebaseDatabase.collection("Users").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                    if error == nil {
                                        for document in snapshot!.documents {
                                            if let userName=document.get("Name") as? String{
                                                if userName == "" {
                                                    screen="userInfo"
                                                } else {
                                                    if (document.get("DateofBirth") as? Timestamp) == nil{
                                                        screen="userBirthDate"
                                                    } else {
                                                        if (document.get("City") as? String) == "" {
                                                            screen="userAddress"
                                                        } else {
                                                            if (document.get("Phone") as? String) == "" {
                                                                screen="userPhone"
                                                            } else {
                                                                screen="userProfile"
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            firebaseDatabase.collection("Stadiums").addSnapshotListener { (snapshot, error) in
                if error==nil {
                    for document in snapshot!.documents{
                        if let userType=document.get("User") as? String{
                            stadiumTypeArray.append(userType)
                            if stadiumTypeArray.contains(currentUser!.uid) {
                                
                                firebaseDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                    if error == nil {
                                        for document in snapshot!.documents {
                                            if let stadiumName=document.get("Name") as? String{
                                                if stadiumName == "" {
                                                    screen="stadiumInfo"
                                                } else {
                                                    if (document.get("City") as? String) == "" {
                                                        screen="stadiumAddress"
                                                    } else {
                                                        if (document.get("Phone") as? String) == "" {
                                                            screen="stadiumPhone"
                                                        } else {
                                                            screen="stadiumProfile"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
