//
//  UserAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI
import Firebase

struct UserAccountView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    @State var uuid=""
    @State var isShowPhotoLibrary=false
    @State var showingAction=false
    @State var image=UIImage()
    @State var isShowCamera=false
    @State var shown=false
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    @ObservedObject var infomodel=UsersInfoModel()
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                        .padding()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .onTapGesture(){
                            showingAction.toggle()
                        }
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
                    .navigationBarItems(trailing:
                                            Button(action: {
                        
                                            }){
                                                Image(systemName: "trash").resizable().frame(width: 30, height: 30)
                                            }
                                        )
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
        }.sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }.sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }.actionSheet(isPresented: $showingAction){
            ActionSheet(
                                title: Text("Fotoğraf Yükle"),
                                buttons: [
                                    .default(Text("Kamera")) {
                                        isShowCamera.toggle()
                                    },
                                    //fotoğrafı seçince yüklesin
                                    .default(Text("Galeri")) {
                                        isShowPhotoLibrary.toggle()
                                    },
                                ]
                            )
        }
    }
    
    func trashClicked(){
        firestoreDatabase.collection("UserProfilePhoto").document(currentUser!.uid).delete { error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                showingAlert.toggle()
            } else {
                let storageRef=self.storage.reference()
                let uuid=self.currentUser!.uid
                let deleteRef=storageRef.child("UserProfile").child("\(uuid).jpg")
                deleteRef.delete { error in
                    if error != nil {
                        titleInput="Hata"
                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        showingAlert.toggle()
                    } else {
                        titleInput="Başarılı"
                        messageInput="Profil fotoğrafınız silinmiştir."
                        showingAlert.toggle()
                    }
                }
            }
        }
    }
    func choosePhoto(){
        infomodel.getDataForUser()
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("UserProfile")
        if let data=image.jpegData(compressionQuality: 0.75) {
             uuid=UUID().uuidString
            
            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metedata, error) in
                if error != nil {
                    titleInput="Hata"
                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    showingAlert.toggle()
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                            let firestoreProfile=["imageUrl":imageUrl!,
                                                 "ID":currentUser!.uid,
                                                 "User":currentUser!.email!,
                                                 "Date":FieldValue.serverTimestamp(),
                                                  "UserName":infomodel.userName] as [String:Any]
                                firestoreDatabase.collection("UserProfilePhoto").document(currentUser!.uid).setData(firestoreProfile) { (error) in
                                if error != nil {
                                    titleInput="Hata"
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    titleInput="Başarılı"
                                    messageInput="Fotoğraf yüklendi."
                                    showingAlert.toggle()
                                    shown.toggle()
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct UserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountView()
    }
}
