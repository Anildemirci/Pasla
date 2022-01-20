//
//  UserInformationView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct UserInformationView: View {
    var body: some View {
        VStack{
            Spacer()
            VStack {
                Text("Kişisel Bilgiler")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color.white)
                VStack{
                    Text("İsim Soyisim")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("Telefon Numarası")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("Şehir")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("İlçe")
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
                    Text("Aldığı randevu sayısı")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    Text("İptal ettiği randevu sayısı")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                    
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25).background(Color.white)
                    .cornerRadius(25)
            }
            Spacer()
        }.background(Color("myGreen"))
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}

class userInfoModel : ObservableObject {
    
    @Published var infos = [String]()
    @Published var address=""
    @Published var open=""
    @Published var close=""
    //yeniden yaz firebase
    init(){
        let db=Firestore.firestore()
        db.collection("Stadiums").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                let address=snapshot?.get("Address") as! String
                self.address=address
                if let openTime=snapshot?.get("Opened") as? String {
                    self.open=openTime
                }
                if let closeTime=snapshot?.get("Closed") as? String {
                    self.close=closeTime
                }
                if let info=snapshot?.get("Informations") as? [String] {
                    self.infos=info
                }
            }
        }
    }
}
