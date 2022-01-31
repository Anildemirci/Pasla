//
//  ConfirmAppointmentView.swift
//  Pasla
//
//  Created by Anıl Demirci on 30.01.2022.
//

import SwiftUI
import Firebase

struct ConfirmAppointmentView: View {
    
    @State var selectedName=""
    @State var documentID=""
    @State var userID=""
    @State var fieldNamee=""
    @State var datee=""
    @State var hourr=""
    @State var name=""
    @State var cancelNumber=Int()
    @State var confirmNumber=Int()
    @State var userPhone=""
    @State var notee=""
    @State var alertType:AlertType?
    @State var messageInput=""
    @State var titleInput=""
    @State var button=""
    @State var button1=""
    @State var button2=""
    @State var shown=false
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    enum AlertType: Identifiable{
        case confirmAlert,showAlert
        
        var id: Int{
            hashValue
        }
    }
    
    var body: some View {
        VStack(){
            ScrollView(.vertical, showsIndicators: false){
                Spacer()
                Text("Saha Bilgileri")
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                Spacer()
                VStack{
                    Group{
                        Text("Saha adı: \(fieldNamee)")
                        Text("Tarih: \(datee)")
                        Text("Saat: \(hourr)")
                        Text("Fiyat: 400₺")
                        Text("Not: \(notee)")
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                Text("Müşteri Bilgileri")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding()
                Spacer()
                VStack{
                    Group{
                        Text("Ad-Soyad: \(name)")
                        Text("Telefon: \(userPhone)")
                        Text("Kapora: 50₺ ödendi.")
                        Text("Tamamladığı randevu sayısı: \(confirmNumber)")
                        Text("İptal ettiği randevu sayısı: \(cancelNumber)")
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45).background(Color.white)
                    .cornerRadius(25)
                Spacer()
                    .frame(height: 50.0)
                VStack{
                    Button(action: {
                        button="send"
                        titleInput="Randevuyu onaylıyor musunuz?"
                        messageInput=""
                        button1="Evet"
                        button2="Hayır"
                        alertType = .confirmAlert
                    }) {
                        Text("Onayla")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.height * 0.06)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                    Button(action: {
                        button="cancel"
                        titleInput="İptal etmek istediğinize emin misiniz?"
                        messageInput=""
                        button1="Evet"
                        button2="Hayır"
                        alertType = .confirmAlert
                    }) {
                        Text("Reddet")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.height * 0.06)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                    Spacer()
                        .frame(height: 25.0)
                }
            }
        }.background(Color("myGreen"))
            .padding()
            .onAppear{
                getInfo()
                userInfo()
            }
            .alert(item:$alertType){ type in
                switch type {
                case .showAlert:
                    return Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Ok!")){
                        if titleInput=="Başarılı" {
                            shown.toggle()
                        }
                    })
                case .confirmAlert:
                    return Alert(title: Text(titleInput), message: Text(messageInput),
                                 primaryButton: .default(Text(button1)){
                               if button=="cancel" {
                                   rejectClicked()
                               } else if button=="send" {
                                   confirmClicked()
                               }
                           },
                                 secondaryButton: .default(Text(button2))
                           )
                }
            }
            .fullScreenCover(isPresented: $shown) { () -> StadiumAccountView in
                return StadiumAccountView()
            }
    }
    
    func getInfo(){
        firestoreDatabase.collection("StadiumAppointments").document(selectedName).collection(selectedName).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let fieldName=document.get("FieldName") as! String
                        fieldNamee=fieldName
                        let date=document.get("AppointmentDate") as! String
                        datee=date
                        let hour=document.get("Hour") as! String
                        hourr=hour
                        //let price=document.get("Price") as! String özelliği ekleyince çek datadan
                        let note=document.get("Note") as! String
                        notee=note
                        let userName=document.get("UserFullName") as! String
                        name=userName
                        let userphone=document.get("UserPhone") as! String
                        userPhone=userphone
                    }
                }
    }
    
    func userInfo(){
        firestoreDatabase.collection("StadiumAppointments").document(selectedName).collection(selectedName).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    if document.documentID == documentID {
                        let userId=document.get("User") as! String
                        self.userID=userId
                    }
                }
            }
            getFromUser()
        }
    }
    
    func getFromUser(){
        firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).whereField("Status", isEqualTo:"İptal edildi.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                cancelNumber=snapshot!.count
            }
    }
        firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).whereField("Status", isEqualTo:"Onaylandı.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                confirmNumber=snapshot!.count
            }
    }
    }
    
    func confirmClicked(){
        self.firestoreDatabase.collection("StadiumAppointments").document(selectedName).collection(selectedName).document(documentID).updateData(["Status":"Onaylandı."])
        self.firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).document(documentID).updateData(["Status":"Onaylandı."])
        self.firestoreDatabase.collection("Calendar").document(selectedName).collection(fieldNamee).document(datee+"-"+hourr).updateData(["Status":"Onaylandı."])
        titleInput="Başarılı"
        messageInput="Randevu onaylanmıştır."
        alertType = .showAlert

    }
    
    func rejectClicked(){
        self.firestoreDatabase.collection("StadiumAppointments").document(selectedName).collection(selectedName).document(self.documentID).updateData(["Status":"Reddedildi."])
        self.firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).document(documentID).updateData(["Status":"Reddedildi."])
        self.firestoreDatabase.collection("Calendar").document(selectedName).collection(fieldNamee).document(datee+"-"+hourr).updateData(["Status":"Reddedildi."])
        titleInput="Başarılı"
        messageInput="Randevu iptal edilmiştir."
        alertType = .showAlert

    }
}

struct ConfirmAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAppointmentView()
    }
}
