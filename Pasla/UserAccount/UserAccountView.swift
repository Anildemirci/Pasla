//
//  UserAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI

struct UserAccountView: View {
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    VStack {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                        .padding()
                    }.background(Color.white)
                    HStack {
                        NavigationLink(destination: MyTeamView()){
                            Text("Takımım")
                                .foregroundColor(Color("myGreen"))
                                .padding()
                                .background(Color.white)
                        }
                        Spacer()
                        NavigationLink(destination: UserInformationView()){
                            Text("Bilgiler")
                                .foregroundColor(Color("myGreen"))
                                .padding()
                                .background(Color.white)
                        }
                        Spacer()
                        NavigationLink(destination: AllAppointmentsView()){
                            Text("Randevular")
                                .foregroundColor(Color("myGreen"))
                                .padding()
                                .background(Color.white)
                        }
                    }
                    Spacer()
                }.background(Color("myGreen"))
            }.tabItem{
                Image(systemName: "person")
                Text("Hesabım")
            }
            FavoriteStadiumsView().tabItem{
                Image(systemName: "star.fill")
                Text("Favoriler")
            }
            FindStadiumView().tabItem{
                Image(systemName: "magnifyingglass")
                Text("Sahalar")
            }
            UserSettingsView().tabItem{
                Image(systemName: "gearshape.fill")
                Text("Ayarlar")
            }
        }
    }
}

struct UserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountView()
    }
}
