//
//  RequestAppointmentView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct RequestAppointmentView: View {
    var numberField=""
    var selectedDate=""
    var selectedHour=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @StateObject var userInfo=UsersInfoModel()
    @State var messageInput=""
    @State var titleInput=""
    @State var showingConfirmAlert=false
    @State var showingAlert=false
    @State var shown=false
    @State var note=""
    
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
                    titleInput="Randevu oluşturmak istediğinizden emin misiniz?"
                    //messageInput="alt mesaj"
                    showingConfirmAlert.toggle()
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
        }
        .alert(isPresented: $showingConfirmAlert){
            Alert(title: Text(titleInput), message: Text(messageInput),
                  primaryButton: .default(Text("Evet!")){
                request()
                shown.toggle()
            },
                  secondaryButton: .default(Text("Hayır!"))
            )
        }
        .fullScreenCover(isPresented: $shown) { () -> UserAccountView in
            return UserAccountView()
        }
        .background(Color("myGreen"))
    }
    
    func request(){
        userInfo.getDataForUser()
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
        let date = dateFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.string(from: NSDate() as Date)
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(date+"-"+time).setData(firestoreUser) {
            error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
            } else {
                titleInput="Başarılı"
                messageInput="Randevu talebiniz gönderildi."
                //kontrolleri gerçekleştir.
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
        
        firestoreDatabase.collection("StadiumAppointments").document(chosenStadiumName).collection(chosenStadiumName).document(date+"-"+time).setData(firestoreStadium) {
            error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
            } else {
                //kontrolleri gerçekleştir
                titleInput="Başarılı"
                messageInput="Randevu talebiniz gönderildi."
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
            }
        }
    }
}

struct RequestAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        RequestAppointmentView()
    }
}
