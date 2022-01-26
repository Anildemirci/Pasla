//
//  StadiumLoginView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI
import Firebase

struct StadiumLoginView: View {
    
    @State var email=""
    @State var password=""
    @State var stadiumTypeArray=[String]()
    @State var showingAlert=false
    @State var messageInput=""
    @State var shown=false
    @State var shownPass=false
    
    var body: some View {
        VStack{
            Spacer()
            HStack {
                Image(systemName: "person")
                TextField("email giriniz", text: $email)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    //.border(Color("myGreen"), width: 4)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                    .autocapitalization(.none).keyboardType(/*@START_MENU_TOKEN@*/.emailAddress/*@END_MENU_TOKEN@*/)
            }.padding()
            HStack {
                Image(systemName: "key")
                if shownPass == false {
                    SecureField("şifre giriniz", text: $password)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                } else {
                    TextField("şifre giriniz", text: $password)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
                }
            }
            if password != "" {
                Button(action: {
                    shownPass.toggle()
                }) {
                    if shownPass == false {
                        Image(systemName: "eye.circle.fill")
                            .foregroundColor(Color("myGreen"))
                        Text("Şifreyi göster")
                            .foregroundColor(Color.black)
                    } else {
                        Image(systemName: "eye.slash.circle.fill")
                            .foregroundColor(Color("myGreen"))
                        Text("Şifreyi gizle")
                            .foregroundColor(Color.black)
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.08 )
            }
            Spacer()
            Button(action: {
                if email != "" && password != "" {
                    let firestoreDatabase=Firestore.firestore()
                    firestoreDatabase.collection("Stadiums").addSnapshotListener { (snapshot, error) in
                        if error == nil {
                            for document in snapshot!.documents
                            {
                                if let userType=document.get("Email") as? String{
                                    stadiumTypeArray.append(userType)
                                }
                            }
                            if stadiumTypeArray.contains(email) {
                                firestoreDatabase.collection("Stadiums").whereField("Email", isEqualTo: email).addSnapshotListener { (snapshot, error) in
                                    if error == nil {
                                                    Auth.auth().signIn(withEmail: email, password: password) { (authdata, error) in
                                                        if error != nil {
                                                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                                            showingAlert.toggle()
                                                        } else {
                                                            shown.toggle()
                                                        }
                                                    }
                                    } else {
                                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        showingAlert.toggle()
                                    }
                                }
                            } else {
                                messageInput=error?.localizedDescription ?? "Email/Şifre kontrol ediniz."
                                showingAlert.toggle()
                            }
                        }
                    }
                } else {
                    messageInput="Lütfen tüm bilgileri giriniz."
                }
            }) {
                Text("Giriş Yap")
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> StadiumAccountView in
                        return StadiumAccountView()
                    }
            }
            Spacer()
        }.alert(isPresented: $showingAlert){
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

var stadiumNamee=""

struct StadiumLoginView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumLoginView()
    }
}
