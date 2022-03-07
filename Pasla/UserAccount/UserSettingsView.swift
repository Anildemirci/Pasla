//
//  UserSettingsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 5.01.2022.
//

import SwiftUI
import Firebase

struct UserSettingsView: View {
    
    @State var newMail=""
    @State var password=""
    @State var password2=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    @State var shown=false
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    var body: some View {
        VStack{
            ScrollView(.vertical,showsIndicators: false) {
                Spacer()
                VStack{
                    Text("Email Değiştir")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    TextField("Yeni e-mail", text: $newMail)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                        .autocapitalization(.none).keyboardType(/*@START_MENU_TOKEN@*/.emailAddress/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        if newMail != "" {
                            currentUser?.updateEmail(to: newMail, completion: { (error) in
                                if error != nil {
                                    titleInput="Hata"
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
                                        if error == nil {
                                            for document in snapshot!.documents{
                                                let documentId=document.documentID
                                                self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Email": newMail])
                                                titleInput="Başarılı"
                                                messageInput="Mail adresiniz değiştirilmiştir."
                                                showingAlert.toggle()
                                            }
                                        }
                                    }
                                }
                            })
                        }else {
                            titleInput="Hata"
                            messageInput="Lütfen yeni mail adresini giriniz."
                            showingAlert.toggle()
                        }
                    }) {
                        Text("Değiştir")
                            .padding()
                            .frame(width: 250.0, height: 50.0)
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.30).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                VStack{
                    Text("Şifre Değiştir")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    SecureField("Yeni şifre", text: $password)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                    SecureField("Yeni şifre tekrar", text: $password2)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                    Button(action: {
                        if password != "" && password2 != "" {
                            if password==password2 {
                                currentUser?.updatePassword(to: password, completion: { (error) in
                                    if error != nil {
                                        titleInput="Hata"
                                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        showingAlert.toggle()
                                    } else {
                                        titleInput="Başarılı"
                                        messageInput="Şifreniz değiştirilmiştir."
                                        showingAlert.toggle()
                                    }
                                })
                            } else {
                                titleInput="Hata"
                                messageInput="Şifreler eşleşmiyor."
                                showingAlert.toggle()
                            }
                        }else {
                            titleInput="Hata"
                            messageInput="Lütfen eksiksiz doldurunuz."
                            showingAlert.toggle()
                        }
                    }) {
                        Text("Değiştir")
                            .padding()
                            .frame(width: 250.0, height: 50.0)
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.40).background(Color.white)
                    .cornerRadius(25)
                
                Spacer()
                Button(action: {
                    do{
                        firestoreDatabase.collection("PlayerID").document(currentUser!.uid).updateData(["Online":"False"])
                        try Auth.auth().signOut()
                        shown.toggle()
                    } catch {
                        print("**Error**")
                    }
                }) {
                    Text("Çıkış")
                        .padding()
                        .frame(width: 250.0, height: 50.0)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .fullScreenCover(isPresented: $shown) { () -> HomeView in
                            return HomeView()
                        }
                }
                Spacer()
            }.background(Color("myGreen"))
            .padding()
                
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
            .onAppear(perform: {
                UIScrollView.appearance().alwaysBounceVertical=true
            })
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
