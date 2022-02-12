//
//  StadiumInfoView.swift
//  Pasla
//
//  Created by Anıl Demirci on 3.01.2022.
//

import SwiftUI
import Firebase

struct StadiumInfoView: View {
    
    @State var name=""
    @State var numberOfField=""
    
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
   
    var hourArray2=["00:30-01:30","01:30-02:30","02:30-03:30","03:30-04:30","04:30-05:30","05:30-06:30","06:30-07:30","07:30-08:30","08:30-09:30","09:30-10:30","10:30-11:30","11:30-12:30","12:30-13:30","13:30-14:30","14:30-15:30","15:30-16:30","16:30-17:30","17:30-18:30","18:30-19:30","19:30-20:30","20:30-21:30","21:30-22:30","22:30-23:30","23:30-00:30"]
    
    var body: some View {
        VStack{
            Spacer()
            TextField("Saha İsmi", text: $name)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .autocapitalization(.words)
            TextField("Saha sayısı", text: $numberOfField)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .keyboardType(.numberPad)
            Spacer()
            Button(action: {
                
                let firestoreDatabese=Firestore.firestore()
                let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                      "Email":Auth.auth().currentUser!.email!,
                                      "Name":name,
                                      "City":"",
                                      "Town":"",
                                      "Phone":"",
                                      "Address":"",
                                      "NumberOfField":numberOfField,
                                      "Type":"Stadium",
                                      "WorkingHour":hourArray,
                                      "WorkingHour2":hourArray2,
                                      "Date":FieldValue.serverTimestamp()] as [String:Any]
                
                if name != "" && numberOfField != "" {
                    firestoreDatabese.collection("Stadiums").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) { error in
                        if error != nil {
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        } else {
                            shown.toggle()
                        }
                    }
                } else {
                    messageInput="Lütfen tüm bilgileri giriniz."
                    showingAlert.toggle()
                }
                
            }) {
                Text("İleri")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> StadiumLocation in
                        return StadiumLocation()
                    }
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

struct StadiumInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumInfoView()
    }
}

struct StadiumLocation: View {
    @State var town=""
    @State var city=""
    @State var address=""
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var body: some View{
        VStack{
            Spacer()
            TextField("İl", text: $city)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .autocapitalization(.words)
            TextField("İlçe", text: $town)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .autocapitalization(.words)
            TextField("Adres", text: $address)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .autocapitalization(.words)
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                if town != "" && city != "" && address != "" {
                    firestoreDatabase.collection("Stadiums").document(Auth.auth().currentUser!.uid).updateData(["City":city,"Town":town,"Address":address]) { error in
                        if error != nil {
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        } else {
                            shown.toggle()
                        }
                    }
                } else {
                    messageInput="Lütfen tüm bilgileri giriniz."
                    showingAlert.toggle()
                }
            }) {
                Text("İleri")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> StadiumPhoneNumber in
                        return StadiumPhoneNumber()
                    }
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

struct StadiumPhoneNumber: View{
    @State var phone=""
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var body: some View{
        VStack{
            Spacer()
            TextField("Telefon", text: $phone)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                .keyboardType(.phonePad)
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                if phone != "" {
                    firestoreDatabase.collection("Stadiums").document(Auth.auth().currentUser!.uid).updateData(["Phone":phone]) { error in
                        if error != nil {
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        } else {
                            shown.toggle()
                        }
                    }
                } else {
                    messageInput="Lütfen tüm bilgileri giriniz."
                    showingAlert.toggle()
                }
            }) {
                Text("Üyeliği tamamla")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> StadiumAccountView in
                        return StadiumAccountView()
                    }
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}
