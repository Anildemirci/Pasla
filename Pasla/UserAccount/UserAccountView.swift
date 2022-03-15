//
//  UserAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import OneSignal

struct UserAccountView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    @State var profilPhoto=""
    @State var uuid=""
    @State var isShowPhotoLibrary=false
    @State var showingAction=false
    @State var image:UIImage?
    @State var isShowCamera=false
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    @State var selection=selectionTab
    
    @ObservedObject var infomodel=UsersInfoModel()
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                VStack {
                    VStack {
                        if image != nil {
                            Image(uiImage: image!)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white,lineWidth:3)).shadow(radius: 25)
                                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                        }
                        else if profilPhoto != "" {
                            CustomImageView(urlString: profilPhoto)
                        }
                        else if profilPhoto == "" {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white,lineWidth:3)).shadow(radius: 25)
                            .onTapGesture(){
                                showingAction.toggle()
                            }
                        }
                    }.frame(width: UIScreen.main.bounds.width * 1.0 , height: UIScreen.main.bounds.height * 0.30).background(Color.white)
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
                    .navigationTitle(Text("Hesabım")).navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading:
                        Button(action: {
                        if image != nil {
                            image=nil
                            profilPhoto=""
                        }
                        }){
                            if image != nil {
                                Image("cancel").resizable().frame(width: 30, height: 30)
                            }
                        }
                    )
                    .navigationBarItems(trailing:
                                            Button(action: {
                        if profilPhoto == "" && image == nil {
                            showingAction.toggle()
                        }
                        else if image != nil {
                            uploadPhoto()
                        }
                        else if profilPhoto != "" {
                            trashClicked()
                        }
                                            }){
                                                if profilPhoto == "" && image == nil {
                                                    Image(systemName: "plus").resizable().frame(width: 30, height: 30)
                                                }
                                                else if image != nil {
                                                    Image("confirm").resizable().frame(width: 30, height: 30).foregroundColor(Color.blue)
                                                }
                                                else if profilPhoto != "" {
                                                    Image(systemName: "trash").resizable().frame(width: 30, height: 30)
                                                }
                                            }
                                        )
            }.onAppear(){
                infomodel.getDataForUser()
                getProfilePhoto()
                pushNotification()
            }
            .tabItem{
                Image(systemName: "person")
                Text("Hesabım")
            }.tag(0)
            FavoriteStadiumsView().tabItem{
                Image(systemName: "star.fill")
                Text("Favoriler")
            }.tag(1)
            FindStadiumView().tabItem{
                Image(systemName: "magnifyingglass")
                Text("Sahalar")
            }.tag(2)
            UserSettingsView().tabItem{
                Image(systemName: "gearshape.fill")
                Text("Ayarlar")
            }.tag(3)
        }.accentColor(Color("myGreen"))
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
                .ignoresSafeArea()
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
                                    .destructive(Text("İptal")) {
                                        
                                    },
                                ]
                            )
        }
    }
    
    func pushNotification(){
        //OneSignal.postNotification(["contents": ["en":"Test Message"], "include_player_ids":["6c98d25a-9d6a-11ec-b2b1-2628c68adadd"]])
        
        if let deviceState = OneSignal.getDeviceState() {
            let playerId = deviceState.userId
            
            if let playerNewId=playerId {
                firestoreDatabase.collection("PlayerId").whereField("User", isEqualTo: currentUser!.uid).getDocuments { (snapshot, error) in
                    if error == nil {
                        if snapshot?.isEmpty == false && snapshot != nil {
                            for document in snapshot!.documents {
                                if let playerID=document.get("PlayerID") as? String {
                                    let documentId=document.documentID
                                    if playerNewId==playerID {
                                        
                                    } else {
                                        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                                              "Email":Auth.auth().currentUser!.email!,
                                                              "PlayerID":playerNewId,
                                                              "Online":"True",
                                                              "Name":infomodel.userName,
                                                              "Type":"User",
                                                              "Date":FieldValue.serverTimestamp()] as [String:Any]
                                        
                                        firestoreDatabase.collection("PlayerID").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) { error in
                                            if error != nil {
                                                //hata
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                                  "Email":Auth.auth().currentUser!.email!,
                                                  "PlayerID":playerNewId,
                                                  "Online":"True",
                                                  "Name":infomodel.userName,
                                                  "Type":"User",
                                                  "Date":FieldValue.serverTimestamp()] as [String:Any]
                            
                            firestoreDatabase.collection("PlayerID").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) { error in
                                if error != nil {
                                    //hata
                                }
                            }
                        }
                    }
                }
            }
            
            
            /*
             let subscribed = deviceState.isSubscribed
             print("Device is subscribed: ", subscribed)
             let hasNotificationPermission = deviceState.hasNotificationPermission
             print("Device has notification permissions enabled: ", hasNotificationPermission)
             let notificationPermissionStatus = deviceState.notificationPermissionStatus
             print("Device's notification permission status: ", notificationPermissionStatus.rawValue)
             let pushToken = deviceState.pushToken
             print("Device Push Token Identifier: ", pushToken ?? "no push token, not subscribed")
             */
        }
        
    }
    
    func getProfilePhoto(){
        firestoreDatabase.collection("UserProfilePhoto").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                if let imageUrl=snapshot?.get("imageUrl") as? String {
                    profilPhoto=imageUrl
                }
            }
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
                        image=nil
                        profilPhoto=""
                    }
                }
            }
        }
    }
    func uploadPhoto(){
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("UserProfile")
        if let data=image?.jpegData(compressionQuality: 0.75) {
            uuid=currentUser!.uid
            
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
                                    image=nil
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

struct CustomImageView: View {
    var urlString: String
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white,lineWidth:3)).shadow(radius: 25)
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: urlString)
            }
    }
}




