//
//  StadiumAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI

struct StadiumAccountView: View {
    var body: some View {
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
                    NavigationLink(destination: StadiumPhotosView()){
                        Text("Fotoğraflar")
                            .foregroundColor(Color("myGreen"))
                            .padding()
                            .background(Color.white)
                    }
                    Spacer()
                    NavigationLink(destination: StadiumInformationsView()){
                        Text("Bilgiler")
                            .foregroundColor(Color("myGreen"))
                            .padding()
                            .background(Color.white)
                    }
                    Spacer()
                    NavigationLink(destination: CommentsView()){
                        Text("Yorumlar")
                            .foregroundColor(Color("myGreen"))
                            .padding()
                            .background(Color.white)
                    }
                }
                Spacer()
                VStack{
                    NavigationLink(destination: UploadPhotos()){
                        Text("Fotoğraf Yükle")
                            .foregroundColor(Color("myGreen"))
                    }.padding()
                        .frame(width: 200.0, height: 50.0)
                        .background(Color.white)
                    NavigationLink(destination: PendingAppointmentsView()){
                        Text("Bekleyen randevular")
                            .foregroundColor(Color("myGreen"))
                    }.padding()
                        .frame(width: 200.0, height: 50.0)
                        .background(Color.white)
                }.padding()
            }.background(Color("myGreen"))
                .navigationTitle(Text("Biral"))
        }
        
    }
}

struct StadiumAccountView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumAccountView()
        StadiumAccountView().previewDevice("iPhone 12 Pro Max")
    }
}
