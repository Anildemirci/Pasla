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
            }
            .onAppear{
            userInfo.getDataForUser()
        }
        }.background(Color("myGreen"))
            
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}
