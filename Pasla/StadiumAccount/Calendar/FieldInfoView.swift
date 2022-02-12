//
//  FieldInfoView.swift
//  Pasla
//
//  Created by Anıl Demirci on 12.02.2022.
//

import SwiftUI
import Firebase

struct FieldInfoView: View {
    
    @State var fieldName=""
    @State var fieldSize=""
    @State var fieldPrice=""
    @State var deposit=""
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    @State var checkInfos=false
    @State var stadiumname=""
    @State var hourtype=["Lütfen saat türünü seçiniz","Tam saatler","Buçuklu saatler"]
    @State var selectedHour="Lütfen saat türünü seçiniz"
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("Saha Bilgileri")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color("myGreen"))
                HStack{
                    TextField("saha boyutu", text: $fieldSize)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                        .autocapitalization(.none).keyboardType(.default)
                    Button(action: {
                        if fieldSize == "" {
                            titleInput="Hata"
                            messageInput="Lütfen saha boyutunu giriniz."
                            showingAlert.toggle()
                        } else {
                            saveInfo(updateInfo: fieldSize, data: "Size")
                        }
                    }) {
                        Text("Ok").scaledToFill()
                            //.padding()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.black)
                            .clipShape(Capsule())
                    }
                }
                HStack{
                    TextField("saha fiyatı", text: $fieldPrice)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                        .autocapitalization(.none).keyboardType(.default)
                    Button(action: {
                        if fieldPrice == "" {
                            titleInput="Hata"
                            messageInput="Lütfen saha fiyatını giriniz."
                            showingAlert.toggle()
                        } else {
                            saveInfo(updateInfo: fieldPrice, data: "Price")
                        }
                    }) {
                        Text("Ok").scaledToFill()
                            //.padding()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.black)
                            .clipShape(Capsule())
                    }
                }
                HStack{
                    TextField("kapora bilgisi", text: $deposit)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                        .autocapitalization(.none).keyboardType(.default)
                    Button(action: {
                        if deposit == "" {
                            titleInput="Hata"
                            messageInput="Lütfen kapora bilgisi giriniz."
                            showingAlert.toggle()
                        } else {
                            saveInfo(updateInfo: deposit, data: "Deposit")
                        }
                    }) {
                        Text("Ok").scaledToFill()
                            //.padding()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.black)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
                HStack{
                    Picker("Lütfen saat türünü seçiniz", selection: $selectedHour) {
                        ForEach(hourtype,id:\.self) { hour in
                            Text(hour)
                                .foregroundColor(Color.black)
                        }
                    }
                    .accentColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        if selectedHour == "Lütfen saat türünü seçiniz" {
                            titleInput="Hata"
                            messageInput="Lütfen saha türünü seçiniz."
                            showingAlert.toggle()
                        } else {
                            if selectedHour == "Buçuklu saatler" {
                                saveInfo(updateInfo: "Half", data: "HourType")
                            } else {
                                saveInfo(updateInfo: "Full", data: "HourType")
                            }
                            
                        }
                    }) {
                        Text("Ok").scaledToFill()
                            //.padding()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.black)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }
            
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear{
            checkInfo()
        }
    }
    
    func saveInfo(updateInfo: String,data:String){
        if checkInfos==false {
            let firestoreField=["User":Auth.auth().currentUser!.uid,
                                "Email":Auth.auth().currentUser!.email!,
                                "Price":fieldPrice,
                                "Size":fieldSize,
                                "Deposit":deposit,
                                "FieldName":fieldName,
                                "HourType":"Full",
                                "Type":"Stadium",
                                "Date":FieldValue.serverTimestamp()] as [String:Any]
            firestoreDatabase.collection("FieldInformations").document(stadiumname).collection("Fields").document(fieldName).setData(firestoreField) { error in
                    if error != nil {
                        titleInput="Hata"
                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        showingAlert.toggle()
                    } else {
                        titleInput="Başarılı"
                        messageInput="Bilgiler düzenlendi"
                        showingAlert.toggle()
                    }
                }
        } else {
            firestoreDatabase.collection("FieldInformations").document(stadiumname).collection("Fields").document(fieldName).updateData([data:updateInfo]) { error in
                    if error != nil {
                        titleInput="Hata"
                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        showingAlert.toggle()
                    } else {
                        titleInput="Başarılı"
                        messageInput="Bilgiler güncellendi"
                        showingAlert.toggle()
                    }
                }
            
            
        }
        }
    
    func checkInfo(){
        firestoreDatabase.collection("FieldInformations").document(stadiumname).collection("Fields").addSnapshotListener { (snapshot, error) in
            if error == nil {
                if snapshot?.isEmpty == true {
                    checkInfos=false
                } else {
                    for document in snapshot!.documents {
                        if document.documentID==fieldName {
                            checkInfos=true
                        }
                    }
                }
                
            }
        }
    }
    
}

struct FieldInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FieldInfoView()
    }
}
