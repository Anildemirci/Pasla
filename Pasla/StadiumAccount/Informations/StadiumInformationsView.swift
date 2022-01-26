//
//  StadiumInformationsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import Firebase

struct StadiumInformationsView: View {
    
    @State var shown=false
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userType=""
    var selectedName=""
    
    @StateObject var infomodel=UsersInfoModel()
    @StateObject var infoModelForUser=StadiumInfoFromUserModel()
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(height: 10.0)
                if userType == "Stadium" { //halı saha girişi için
                    HStack{
                        Image(systemName: "map.fill")
                            .resizable()
                            .foregroundColor(Color.blue)
                            .frame(width: 50.0, height: 50.0)
                            .aspectRatio(contentMode: .fill)
                        Text(infomodel.stadiumAddress)
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                    .background(Color.white)
                    .cornerRadius(25)
                    Spacer()
                        .frame(height: 25.0)
                    VStack{
                        Spacer()
                        Text("Açılış saati: \(infomodel.stadiumOpen)")
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                        Spacer()
                        Text("Kapanış saati: \(infomodel.stadiumClose)")
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.15)
                    .background(Color.white)
                    .cornerRadius(25)
                    Spacer()
                    
                        Text("Saha Hakkında").font(.title).foregroundColor(.white)
                        let infoArray=infomodel.stadiumInfos
                    if infoArray.isEmpty {
                        Text("Henüz saha tarafından bilgi girilmedi")
                            .foregroundColor(Color.black)
                            .font(.title3)
                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.white)
                            .cornerRadius(25)
                    } else {
                        List(infoArray,id:\.self) { i in
                                Text(i)
                                    .foregroundColor(Color.black)
                                    .font(.title3)
                        }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                        .background(Color.white)
                        .cornerRadius(25)
                    }
                }
                
                else { //user girişi için
                    HStack{
                        Image(systemName: "map.fill")
                            .resizable()
                            .foregroundColor(Color.blue)
                            .frame(width: 50.0, height: 50.0)
                            .aspectRatio(contentMode: .fill)
                        Text(infoModelForUser.address)
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                    .background(Color.white)
                    .cornerRadius(25)
                    Spacer()
                        .frame(height: 25.0)
                    VStack{
                        Spacer()
                        Text("Açılış saati: \(infoModelForUser.open)")
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                        Spacer()
                        Text("Kapanış saati: \(infoModelForUser.close)")
                            .font(.title3)
                            .foregroundColor(Color("myGreen"))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.15)
                    .background(Color.white)
                    .cornerRadius(25)
                    Spacer()
                    
                        Text("Saha Hakkında").font(.title).foregroundColor(.white)
                        let infoArray=infoModelForUser.infos
                    if infoArray.isEmpty {
                        Text("Henüz saha tarafından bilgi girilmedi")
                            .foregroundColor(Color.black)
                            .font(.title3)
                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.white)
                            .cornerRadius(25)
                    } else {
                        List(infoArray,id:\.self) { i in
                                Text(i)
                                    .foregroundColor(Color.black)
                                    .font(.title3)
                        }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                        .background(Color.white)
                        .cornerRadius(25)
                    }
                }
            }.onAppear{
                if userType=="Stadium" {
                    infomodel.getDataForStadium()
                } else {
                    infoModelForUser.getDataFromInfoForUser()
                }
            }.navigationBarItems(trailing:
                                    Button(action: {
                                    shown.toggle()
                                    }){
                                        if userType != "Stadium" {
                                            hidden()
                                        } else {
                                            Image(systemName: "plus").resizable().frame(width: 30, height: 30)
                                                .sheet(isPresented: $shown) { () -> StadiumEditView in
                                                    return StadiumEditView()
                                                }
                                        }
                                        
                                    }
                                )
                .background(Color("myGreen"))
        }
    }
}


struct StadiumInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumInformationsView()
    }
}



