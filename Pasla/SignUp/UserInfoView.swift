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
    @State var birthDay=""
    @State var city=""
    @State var town=""
    @State var phone=""
    
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
            TextField("Doğum tarihi", text: $birthDay)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
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
            TextField("Telefon", text: $phone)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            Spacer()
            Button(action: {
                let firestoreDatabase=Firestore.firestore()
                let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser?.email,
                                   "Name":name,
                                   "Surname":surname,
                                   "DateofBirth":birthDay,
                                   "City":city,
                                   "Town":town,
                                   "Phone":phone,
                                   "Type":"User",
                                   "Date":FieldValue.serverTimestamp()] as [String:Any]
                if name != "" && surname != "" && birthDay != "" && city != "" && town != "" && phone != "" {
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
                Text("Onayla")
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
