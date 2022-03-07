//
//  UserInformationView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct UserInformationView: View {
    @ObservedObject var userInfo=UsersInfoModel()
    @State var confirmedNumber=Int()
    @State var canceledNumber=Int()
    var firedatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
            Spacer()
            VStack {
                Text("Kişisel Bilgiler")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color.white)
                VStack{
                    Text("İsim Soyisim: "+userInfo.userName+" "+userInfo.userSurname)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("Telefon Numarası: "+userInfo.userPhone)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("Şehir: "+userInfo.userCity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("İlçe: "+userInfo.userTown)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.40).background(Color.white)
                    .cornerRadius(25)
            }
            Spacer()
            VStack {
                Text("Randevu Bilgileri")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color.white)
                VStack{
                    Text("Aldığı randevu sayısı: \(String(confirmedNumber))").scaledToFill()
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("İptal ettiği randevu sayısı: \(String(canceledNumber))").scaledToFill()
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25).background(Color.white)
                    .cornerRadius(25)
            }
            Spacer()
            }
            .onAppear{
            userInfo.getDataForUser()
                getData()
        }
        }.background(Color("myGreen"))
            
    }
    
    func getData(){
        firedatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo:"İptal edildi.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.canceledNumber=snapshot!.count
            }
    }
        firedatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo:"Onaylandı.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.confirmedNumber=snapshot!.count
            }
    }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}
