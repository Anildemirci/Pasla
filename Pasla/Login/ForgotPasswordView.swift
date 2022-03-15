//
//  ForgotPasswordView.swift
//  Pasla
//
//  Created by Anıl Demirci on 4.02.2022.
//

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    
    @State var email=""
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    var firebaseDatabase=Firestore.firestore()
    var body: some View {
        VStack{
            Text("Şifre yenile")
                .font(.largeTitle)
                .padding()
            TextField("email giriniz", text: $email)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            if email != "" {
                Button(action: {
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if error != nil {
                            titleInput="Hata"
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            showingAlert.toggle()
                        } else {
                            titleInput="Başarılı"
                            messageInput="Email adresinize şifrenizi resetlemek için link yollanmıştır."
                            showingAlert.toggle()
                        }
                    }
                }) {
                    Text("Reset")
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            } else {
                Button(action: {
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if error != nil {
                            titleInput="Hata"
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            showingAlert.toggle()
                        } else {
                            titleInput="Başarılı"
                            messageInput="Email adresinize şifrenizi resetlemek için link yollanmıştır."
                            showingAlert.toggle()
                        }
                    }
                }) {
                    Text("Reset")
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .opacity(0.4)
                }.disabled(true)
            }
            Spacer()
        }.onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showingAlert){
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
