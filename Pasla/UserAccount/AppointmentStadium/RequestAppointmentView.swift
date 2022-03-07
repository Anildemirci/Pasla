//
//  RequestAppointmentView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase
import OneSignal

struct RequestAppointmentView: View {
    var numberField=""
    var selectedDate=""
    var selectedHour=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @StateObject var userInfo=UsersInfoModel()
    @StateObject var stadiumInfo=StadiumInfoFromUserModel()
    @State var messageInput=""
    @State var titleInput=""
    @State var button=""
    @State var button1=""
    @State var button2=""
    @State var shown=false
    @State var note=""
    @State var alertType:AlertType?
    
    enum AlertType: Identifiable{
        case confirmAlert,showAlert
        
        var id: Int{
            hashValue
        }
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                Spacer()
                    .padding(10)
                Text(chosenTown)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                    .background(Color.white)
                Spacer()
                    .padding(10)
                VStack{
                    Group{
                        Text("Saha numarası: \(numberField)")
                        Text("Tarih: \(selectedDate)")
                        Text("Saat: \(selectedHour)")
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .multilineTextAlignment(.leading)
                        .border(Color("myGreen"), width: 1)
                    Text("Notlarınız")
                        .padding()
                    TextField("Sahaya iletmek istedikleriniz", text: $note)
                        .padding()
                        .border(Color("myGreen"), width: 1)
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45).background(Color.white)
                        .cornerRadius(25)
                Spacer()
                    .padding(10)
                Button(action: {
                    titleInput="Onaylıyor musunuz?"
                    //messageInput=""
                    button1="Evet"
                    button2="Hayır"
                    alertType = .confirmAlert
                }){
                    Text("Randevu talep et")
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                        .background(Color.white)
                }
            }
        }
        .onAppear{
            userInfo.getDataForUser()
        }.onTapGesture {
            hideKeyboard()
        }.alert(item:$alertType){ type in
            switch type {
            case .showAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Tamam!")){
                    if titleInput=="Başarılı" {
                        shown.toggle()
                    }
                })
            case .confirmAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput),
                             primaryButton: .default(Text(button1)){
                    request()
                       },
                             secondaryButton: .default(Text(button2))
                       )
            }
        }
        .fullScreenCover(isPresented: $shown) { () -> UserAccountView in
            return UserAccountView()
        }
        .background(Color("myGreen"))
    }
    
    func request(){
        userInfo.getDataForUser()
        stadiumInfo.getDataFromInfoForUser()
        
        let firestoreDatabase=Firestore.firestore()
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email,
                           "Type":"User",
                           "StadiumName":chosenStadiumName,
                           "FieldName":numberField,
                           "Hour":selectedHour,
                           //"Price":priceLabel.text!, fiyat ve kapora ekle
                           "Note":note,
                           "AppointmentDate":selectedDate,
                           "Status":"Onay bekliyor.",
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .medium
        timeFormatter.dateFormat = "HH:mm:ss" //24 saatlik format için
        let date = dateFormatter.string(from: NSDate() as Date) //bugünün tarihi
        let time = timeFormatter.string(from: NSDate() as Date) //anlık saat örn. saat:dk:sn
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(selectedDate+"-"+selectedHour).setData(firestoreUser) {
            error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
            } else {
                titleInput="Başarılı"
                messageInput="Randevu talebiniz gönderildi."
            }
        }
        
        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                              "Email":Auth.auth().currentUser!.email!,
                              "Type":"User",
                              "StadiumName":chosenStadiumName,
                              "FieldName":numberField,
                              "Hour":selectedHour,
                              //"Price":priceLabel.text!,
                              "Note":note,
                              "AppointmentDate":selectedDate,
                              "Status":"Onay bekliyor.",
                              "UserFullName":userInfo.userName+" "+userInfo.userSurname,
                              "UserPhone":userInfo.userPhone,
                              "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("StadiumAppointments").document(chosenStadiumName).collection(chosenStadiumName).document(selectedDate+"-"+selectedHour).setData(firestoreStadium) {
            error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                alertType = .showAlert
            } else {
                //kontrolleri gerçekleştir
                firestoreDatabase.collection("PlayerID").whereField("Name", isEqualTo: chosenStadiumName).getDocuments { (snapshot, error) in
                    if error == nil {
                        if snapshot?.isEmpty == false && snapshot != nil {
                            for document in snapshot!.documents {
                                if let playerId=document.get("PlayerID") as? String{                                    
                                    let status=document.get("Online") as? String
                                    if status=="True" {
                                        OneSignal.postNotification(["contents": ["en":"Yeni bir randevu talebi!"], "include_player_ids":["\(playerId)"]])
                                        print(stadiumInfo.id)
                                    }
                                }
                            }
                        }
                    }
                }
                
                titleInput="Başarılı"
                messageInput="Randevu talebiniz gönderildi."
                alertType = .showAlert
            }
        }
        
        let firestoreCalendar=["User":Auth.auth().currentUser!.uid,
                               "Email":Auth.auth().currentUser!.email!,
                               "Type":"User",
                               "StadiumName":chosenStadiumName,
                               "FieldName":numberField,
                               "Hour":selectedHour,
                               "AppointmentDate":selectedDate,
                               //"Price":priceLabel.text!,
                               "Status":"Onay bekliyor.",
                               "Date":FieldValue.serverTimestamp()] as [String:Any]
        firestoreDatabase.collection("Calendar").document(chosenStadiumName).collection(numberField).document(selectedDate+"-"+selectedHour).setData(firestoreCalendar) {
            error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                alertType = .showAlert
            }
        }
    }
}

struct RequestAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        RequestAppointmentView()
    }
}
