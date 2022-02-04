//
//  StadiumSignUpView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct StadiumSignUpView: View {
    
    @State var email=""
    @State var password=""
    @State var password2=""
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
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
            }
            HStack {
                Image(systemName: "key")
                TextField("şifre giriniz", text: $password)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            }.padding()
            HStack{
                Image(systemName: "key")
                TextField("tekrar şifre giriniz", text: $password2)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            }
            Spacer()
            Button(action: {
                if email != "" && password != "" && password2 != "" {
                    if password == password2 {
                        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                            if error != nil {
                                messageInput=error?.localizedDescription ?? "Hata!"
                                showingAlert.toggle()
                            } else {
                                let firestoreDatabese=Firestore.firestore()
                                let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                                      "Email":Auth.auth().currentUser?.email,
                                                      "Name":"",
                                                      "City":"",
                                                      "Town":"",
                                                      "Phone":"",
                                                      "Address":"",
                                                      "NumberOfField":"",
                                                      "Type":"Stadium",
                                                      "Date":FieldValue.serverTimestamp()] as [String:Any]
                                
                                firestoreDatabese.collection("Stadiums").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) { error in
                                    if error != nil {
                                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        showingAlert.toggle()
                                    } else {
                                        shown.toggle()
                                    }
                                }
                            }
                        }
                    } else {
                        messageInput="Şifreler eşleşmiyor."
                        showingAlert.toggle()
                    }
                } else {
                    messageInput="Lütfen tüm bilgileri giriniz."
                    showingAlert.toggle()
                }
            }) {
                Text("Kayıt Ol")
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $shown) { () -> StadiumInfoView in
                        return StadiumInfoView()
                    }
            }
            Button(action: {
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                // Create Google Sign In configuration object.
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, error in

                  if let error = error {
                    //error.localizedDescription
                    return
                  }

                  guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                  else {
                    return
                  }

                  let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                 accessToken: authentication.accessToken)
                    
                    Auth.auth().signIn(with: credential) { result, error in
                        if error != nil {
                            messageInput=error?.localizedDescription ?? "Hata!"
                            showingAlert.toggle()
                        } else {
                            let firestoreDatabase=Firestore.firestore()
                            let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                               "Email":Auth.auth().currentUser?.email,
                                               "Name":"",
                                               "Surname":"",
                                               "DateofBirth":"",
                                               "City":"",
                                               "Town":"",
                                               "Phone":"",
                                               "Type":"User",
                                               "Date":FieldValue.serverTimestamp()] as [String:Any]
                            
                            firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { error in
                                if error != nil {
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    shown.toggle()
                                }
                            }
                        }
                    }
                  // ...
                }
            }) {
                HStack{
                    Image("google")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    Text("Hesap Oluştur")
                        .font(.title3)
                        .fontWeight(.medium)
                        .kerning(1.1)
                }.padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .background(Color.white)
                    .foregroundColor(Color.blue)
                    .overlay(Capsule().stroke(Color.blue,lineWidth:3))
            }.padding()
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert){
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}


struct StadiumSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumSignUpView()
    }
}
