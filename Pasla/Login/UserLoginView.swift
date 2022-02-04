//
//  UserLoginView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI
import Firebase

struct UserLoginView: View {
    
    @State var email=""
    @State var password=""
    @State var userTypeArray=[String]()
    @State var messageInput=""
    @State var showingAlert=false
    @State var shown=false
    @State var shownPass=false
    @State var forgotPass=false
    
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
                    .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3)).autocapitalization(.none).keyboardType(.emailAddress)
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
                forgotPass.toggle()
            }) { Text("Şifremi unuttum")
                
            }
            Spacer()
            Button(action: {
                if email != "" && password != "" {
                    let firestoreDatabase=Firestore.firestore()
                    firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
                        if error == nil {
                            for document in snapshot!.documents
                            {
                                if let userType=document.get("Email") as? String{
                                    userTypeArray.append(userType)
                                }
                            }
                            if userTypeArray.contains(email) {
                                firestoreDatabase.collection("Users").whereField("Email", isEqualTo: email).addSnapshotListener { (snapshot, error) in
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
                    showingAlert.toggle()
                }
            }) {
                Text("Giriş Yap")
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> UserAccountView in
                        return UserAccountView()
                    }
            }
            Spacer()
        }.alert(isPresented: $showingAlert){
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }.onTapGesture {
            hideKeyboard()
        }.sheet(isPresented: $forgotPass) { () -> ForgotPasswordView in
            return ForgotPasswordView()
        }
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView()
    }
}
