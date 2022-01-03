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
    @State var address=""
    @State var city=""
    @State var town=""
    @State var phone=""
    
    @State var shown=false
    @State var messageInput=""
    @State var showingAlert=false
    
    var body: some View {
        VStack{
            Spacer()
            TextField("Saha İsmi", text: $name)
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
            TextField("Adres", text: $address)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            TextField("Telefon", text: $phone)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            TextField("Saha sayısı", text: $numberOfField)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color("myGreen"),lineWidth:3))
            Spacer()
            Button(action: {
                
                let firestoreDatabese=Firestore.firestore()
                let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                      "Email":Auth.auth().currentUser?.email,
                                      "Name":name,
                                      "City":city,
                                      "Town":town,
                                      "Phone":phone,
                                      "Address":address,
                                      "NumberOfField":numberOfField,
                                      "Type":"Stadium",
                                      "Date":FieldValue.serverTimestamp()] as [String:Any]
                
                if name != "" && city != "" && town != "" && address != "" && phone != "" && numberOfField != "" {
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
                Text("Onayla")
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
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Hata!"), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
}

struct StadiumInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumInfoView()
    }
}
