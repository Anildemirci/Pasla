//
//  UserInfoView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI
import Firebase

struct UserInfoView: View {
    @State var name=""
    @State var surname=""
    
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var body: some View {
        VStack{
            Spacer()
            TextField("İsim", text: $name)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            TextField("Soyisim", text: $surname)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser!.email!,
                                   "Name":name,
                                   "Surname":surname,
                                   "DateofBirth":"",
                                   "City":"",
                                   "Town":"",
                                   "Phone":"",
                                   "Type":"User",
                                   "Date":FieldValue.serverTimestamp()] as [String:Any]
                if name != "" && surname != "" {
                    firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { error in
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
                    .fullScreenCover(isPresented: $shown) { () -> UserBirthday in
                        return UserBirthday()
                    }
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert){
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}

struct UserBirthday: View {
    //@State var day=""
    //@State var month=""
    @State var year=""
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    @State var birthDate=Date()
    
    var body: some View{
        VStack {
            Spacer()
            Text("Doğum Gününüz")
            Form {
                DatePicker("", selection: $birthDate, in: ...Date(),displayedComponents: .date)
                    .datePickerStyle(.wheel)
            }
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                if birthDate != nil {
                    firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["DateofBirth":birthDate]) { error in
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
                    .fullScreenCover(isPresented: $shown) { () -> UserLocation in
                        return UserLocation()
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

struct UserLocation: View {
    @State var town=""
    @State var city=""
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
            TextField("İlçe", text: $town)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                if town != "" && city != "" {
                    firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["City":city,"Town":town]) { error in
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
                    .fullScreenCover(isPresented: $shown) { () -> UserPhoneNumber in
                        return UserPhoneNumber()
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

struct UserPhoneNumber: View{
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
                    firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).updateData(["Phone":phone]) { error in
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
                    .fullScreenCover(isPresented: $shown) { () -> UserAccountView in
                        return UserAccountView()
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
