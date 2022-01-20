//
//  StadiumEditView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.01.2022.
//

import SwiftUI
import Firebase

struct StadiumEditView: View {
    @State var village=""
    @State var street=""
    @State var town=""
    @State var city=""
    @State var info=""
    @State var openingTime=""
    @State var closingTime=""
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var body: some View {
        VStack{
        ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .padding(10)
                //map ekle
                VStack{
                    Text("Adres Bilgileri")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    TextField("mahalle", text: $village)
                        .padding()
                        .border(Color.black, width: 2)
                    TextField("cadde,sokak,no", text: $street)
                        .padding()
                        .border(Color.black, width: 2)
                    HStack{
                        TextField("ilçe", text: $town)
                            .padding()
                            .border(Color.black, width: 2)
                        TextField("il", text: $city)
                            .padding()
                            .border(Color.black, width: 2)
                    }
                    Button(action: {
                        if village != "" && street != "" && town != "" && city != "" {
                            firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Address": (village)+",\(street)"+",\(town)"+"/\(city)"])
                                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Town":town])
                                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["City":city])
                                        titleInput="Başarılı"
                                        messageInput="Adres bilgileriniz değiştirilmiştir."
                                        showingAlert.toggle()
                                    }
                                }
                            }
                        } else {
                            titleInput="Hata"
                            messageInput="Lütfen tüm bilgileri giriniz."
                            showingAlert.toggle()
                        }
                    })
                    {
                        Text("Düzenle")
                            .padding()
                            .frame(width: 250.0, height: 50.0)
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.50).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                    .padding(10)
                VStack{
                    Text("Çalışma Saatleri")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    HStack{
                        TextField("Açılış saati", text: $openingTime)
                            .padding()
                            .border(Color.black, width: 2)
                        TextField("Kapanış saati", text: $closingTime)
                            .padding()
                            .border(Color.black, width: 2)
                    }
                    Button(action: {
                        if openingTime != "" && closingTime != "" {
                            firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        if document.get("Opened") != nil && document.get("Closed") != nil {
                                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Opened":openingTime])
                                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Closed":closingTime])
                                            }
                                        else {
                                            let addOpened=["Opened":self.openingTime,
                                                           "Closed":self.closingTime] as [String:Any]
                                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addOpened, merge: true)
                                            titleInput="Başarılı"
                                            messageInput="Çalışma saatleri değiştirilmiştir."
                                            showingAlert.toggle()
                                        }
                                    }
                                }
                            }
                        } else {
                            titleInput="Hata"
                            messageInput="Lütfen tüm bilgileri giriniz."
                            showingAlert.toggle()
                        }
                    })
                    {
                        Text("Onayla")
                            .padding()
                            .frame(width: 250.0, height: 50.0)
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.30).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                    .padding(10)
                VStack{
                    Text("Saha Bilgileri")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    TextField("bilgi(kamera var,3 adet saha var", text: $info)
                        .padding()
                        .border(Color.black, width: 2)
                    Button(action: {
                        if info != "" {
                            firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        if var infoArray=document.get("Informations") as? [String] {
                                            infoArray.append(info)
                                            let addInfo=["Informations":infoArray] as [String:Any]
                                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addInfo, merge: true) { (error) in
                                                if error == nil {
                                                    titleInput="Başarılı"
                                                    messageInput="Bilgi eklendi."
                                                    showingAlert.toggle()
                                                }
                                            }
                                        }else {
                                            let addInfo=["Informations":[self.info]] as [String:Any]
                                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addInfo, merge: true)
                                            titleInput="Başarılı"
                                            messageInput="Bilgi eklendi."
                                            showingAlert.toggle()
                                        }
                                    }
                                }
                            }
                        } else {
                            titleInput="Hata"
                            messageInput="Lütfen tüm bilgileri giriniz."
                            showingAlert.toggle()
                        }
                    })
                    {
                        Text("Ekle")
                            .padding()
                            .frame(width: 250.0, height: 50.0)
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.30).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                    .padding(10)
            }.background(Color("myGreen"))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
                }
        }
    }
}

struct StadiumEditView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumEditView()
    }
}
