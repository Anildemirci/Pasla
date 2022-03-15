//
//  SelectedStadiumView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct SelectedStadiumView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var selectedStadium=""
    
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    @State var favCheck=false
    @State var profilPhoto=""
    
    @StateObject var userInfo=UsersInfoModel()
    
    var body: some View {
                VStack {
                    VStack {
                        if profilPhoto != "" {
                            AnimatedImage(url: URL(string: profilPhoto))
                                .resizable()
                                //.aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                            .padding()
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                            
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                            .padding()
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        }
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
                        NavigationLink(destination: AppointmentView()){
                            Text("Randevu Al")
                                .foregroundColor(Color.black)
                        }.padding()
                            .frame(width: 200.0, height: 50.0)
                            .background(Color.white)
                    }.padding()
                }.onAppear{
                    userInfo.getDataForUser()
                    getProfilPhoto()
                }
                .background(Color("myGreen"))
                .navigationTitle(Text(selectedStadium)).navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    if userInfo.userFavStadium.contains(selectedStadium) {
                        delFavorite()
                    } else {
                        addFavorite()
                    }
                }){
                    if userInfo.userFavStadium.contains(selectedStadium) {
                        Image(systemName: "star.fill").resizable().frame(width: 30, height: 30)
                            .foregroundColor(Color.yellow)
                    } else {
                        Image(systemName: "star").resizable().frame(width: 30, height: 30)
                    }
                })
                    .alert(isPresented: $showingAlert){
                        Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
                    }
    }
    
    func getProfilPhoto(){
        firestoreDatabase.collection("ProfilePhoto").whereField("StadiumName", isEqualTo: selectedStadium).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if document.get("imageUrl") != nil {
                        let imageUrl=document.get("imageUrl") as! String
                        profilPhoto=imageUrl
                    }
                }
            }
        }
    }
    
    
    func addFavorite(){
        self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: self.currentUser?.uid).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let documentId=document.documentID
                    if var favArray=document.get("FavoriteStadiums") as? [String] {
                        if favArray.contains(selectedStadium) {
                            favCheck.toggle()
                        } else {
                            favArray.append(selectedStadium)
                            let addFavStadium=["FavoriteStadiums":favArray] as [String:Any]
                            self.firestoreDatabase.collection("Users").document(documentId).setData(addFavStadium, merge: true) { (error) in
                                if error == nil {
                                    favCheck.toggle()
                                    titleInput="Başarılı"
                                    messageInput="Saha favorilerinize eklenmiştir."
                                    showingAlert.toggle()
                                }
                            }
                        }
                    }else {
                        let addFavStadium=["FavoriteStadiums":[selectedStadium]] as [String:Any]
                        self.firestoreDatabase.collection("Users").document(documentId).setData(addFavStadium, merge: true)
                        favCheck.toggle()
                        titleInput="Başarılı"
                        messageInput="Saha favorilerinize eklenmiştir."
                        showingAlert.toggle()
                    }
                }
            }
        }
    }
    func delFavorite(){
        firestoreDatabase.collection("Users").document(currentUser!.uid).updateData(["FavoriteStadiums":FieldValue.arrayRemove([selectedStadium])])
        favCheck.toggle()
        titleInput="Başarılı"
        messageInput="Saha favorilerinizden çıkartılmıştır."
        showingAlert.toggle()
    }
}

struct SelectedStadiumView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedStadiumView()
    }
}


