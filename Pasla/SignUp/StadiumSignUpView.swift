//
//  StadiumSignUpView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI
import Firebase
//import GoogleSignIn

struct StadiumSignUpView: View {
    
    @State var email=""
    @State var password=""
    @State var password2=""
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]

    var hourArray2=["00:30-01:30","01:30-02:30","02:30-03:30","03:30-04:30","04:30-05:30","05:30-06:30","06:30-07:30","07:30-08:30","08:30-09:30","09:30-10:30","10:30-11:30","11:30-12:30","12:30-13:30","13:30-14:30","14:30-15:30","15:30-16:30","16:30-17:30","17:30-18:30","18:30-19:30","19:30-20:30","20:30-21:30","21:30-22:30","22:30-23:30","23:30-00:30"]
    
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
                    .autocapitalization(.none).keyboardType(.emailAddress)
            }
            HStack {
                Image(systemName: "key")
                SecureField("şifre giriniz", text: $password)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            }.padding()
            HStack{
                Image(systemName: "key")
                SecureField("tekrar şifre giriniz", text: $password2)
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
                                                      "Email":Auth.auth().currentUser!.email!,
                                                      "Name":"",
                                                      "City":"",
                                                      "Town":"",
                                                      "Phone":"",
                                                      "Address":"",
                                                      "NumberOfField":"",
                                                      "Type":"Stadium",
                                                      "WorkingHour":hourArray,
                                                      "WorkingHour2":hourArray2,
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

/*
 google ile giriş butonu
 
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
                                    "Email":Auth.auth().currentUser!.email!,
                                    "Name":"",
                                    "Surname":"",
                                    "DateofBirth":"",
                                    "City":"",
                                    "Town":"",
                                    "Phone":"",
                                    "Type":"User",
                                    "WorkingHour":[hourArray],
                                    "WorkingHour2":[hourArray2],
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
 */
