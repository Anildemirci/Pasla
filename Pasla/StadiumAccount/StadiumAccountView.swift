//
//  StadiumAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI
import Firebase

struct StadiumAccountView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()

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
                        .navigationBarItems(trailing:
                                                Button(action: {
                            trashClicked()
                                                }){
                                                    Image(systemName: "trash").resizable().frame(width: 30, height: 30)
                                                }
                                            )
            }.tabItem{
                Image(systemName: "person")
                Text("Hesabım")
            }
            CalendarView().tabItem{
                Image(systemName: "calendar")
                Text("Takvim")
            }
            StadiumSettingsView().tabItem{
                Image(systemName: "gearshape.fill")
                Text("Ayarlar")
            }
        }
    }
    func trashClicked(){
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).delete { error in
            if error != nil {
                //error localized
            } else {
                let storageRef=self.storage.reference()
                let uuid=self.currentUser!.uid
                let deleteRef=storageRef.child("Profile").child("\(uuid).jpg")
                deleteRef.delete { error in
                    if error != nil {
                        //error fotoğraf silinemedi localized
                    } else {
                       //silindi
                    }
                }
            }
        }
    }
}

struct StadiumAccountView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumAccountView()
    }
}
