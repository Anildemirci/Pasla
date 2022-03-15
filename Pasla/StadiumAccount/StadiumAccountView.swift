//
//  StadiumAccountView.swift
//  Pasla
//
//  Created by Anıl Demirci on 18.12.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import OneSignal

struct StadiumAccountView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    @State var profilPhoto=""
    @State var uuid=""
    @State var isShowPhotoLibrary=false
    @State var showingAction=false
    @State var image:UIImage?
    @State var isShowCamera=false
    @State var shown=false
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    @StateObject var infomodel=UsersInfoModel()
    @StateObject var photoModel=StadiumPhotosModel()
    
    var body: some View {
        TabView {
            NavigationView {
                    VStack {
                        VStack {
                            if image != nil {
                                Image(uiImage: image!)
                                    .resizable()
                                    //.aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                            }
                            else if profilPhoto != "" {
                                AnimatedImage(url: URL(string: profilPhoto))
                                    .resizable()
                                    //.aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                            }
                            else if profilPhoto == "" {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 1 , height: UIScreen.main.bounds.height * 0.20)
                                .padding()
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                                .onTapGesture(){
                                    showingAction.toggle()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width * 1.0 , height: UIScreen.main.bounds.height * 0.30).background(Color.white)
                        HStack {
                            NavigationLink(destination: StadiumPhotosView(userType:infomodel.stadiumType,selectedName: infomodel.stadiumName).onAppear(){
                            }){
                                Text("Fotoğraflar")
                                    .foregroundColor(Color("myGreen"))
                                    .padding()
                                    .background(Color.white)
                            }
                            Spacer()
                            NavigationLink(destination: StadiumInformationsView(userType:infomodel.stadiumType,selectedName: infomodel.stadiumName)){
                                Text("Bilgiler")
                                    .foregroundColor(Color("myGreen"))
                                    .padding()
                                    .background(Color.white)
                            }
                            Spacer()
                            NavigationLink(destination: CommentsView(selectedStadium: infomodel.stadiumName)){
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
                                .frame(width: UIScreen.main.bounds.width * 0.6, height: 50.0)
                                .background(Color.white)
                            if infomodel.appointmentsArray.count == 0 {
                                NavigationLink(destination: PendingAppointmentsView(selectedName:infomodel.stadiumName)){
                                    Text("Bekleyen randevunuz yok")
                                        .font(.footnote)
                                        .scaledToFit()
                                        .foregroundColor(Color("myGreen"))
                                }.padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50.0)
                                    .background(Color.white)
                                    .disabled(true)
                            } else {
                                NavigationLink(destination: PendingAppointmentsView(selectedName:infomodel.stadiumName)){
                                    Text("Bekleyen \(infomodel.appointmentsArray.count) adet randevu").scaledToFill()
                                            .foregroundColor(Color("myGreen"))
                                }.padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50.0)
                                    .background(Color.white)
                            }
                        }.padding()
                    }.background(Color("myGreen")).navigationTitle(Text(infomodel.stadiumName)).navigationBarTitleDisplayMode(.inline)
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
            }
            .onAppear(){
                infomodel.getDataForStadium()
                infomodel.getAppointment()
                getProfilePhoto()
                pushNotification()
            }
            .tabItem{
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
        }.accentColor(Color("myGreen"))
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }.sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
        .actionSheet(isPresented: $showingAction){
            ActionSheet(
                                title: Text("Fotoğraf Yükle"),
                                buttons: [
                                    .default(Text("Kamera")) {
                                        isShowCamera.toggle()
                                    },
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
                                                              "Name":infomodel.stadiumName,
                                                              "Online":"True",
                                                              "Type":"Stadium",
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
                                                  "Name":infomodel.stadiumName,
                                                  "Online":"True",
                                                  "Type":"Stadium",
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
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                if let imageUrl=snapshot?.get("imageUrl") as? String {
                    profilPhoto=imageUrl
                }
            }
        }
    }
    
    func trashClicked(){
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).delete { error in
            if error != nil {
                titleInput="Hata"
                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                showingAlert.toggle()
            } else {
                let storageRef=self.storage.reference()
                let uuid=self.currentUser!.uid
                let deleteRef=storageRef.child("Profile").child("\(uuid).jpg")
                deleteRef.delete { error in
                    if error != nil {
                        titleInput="Hata"
                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        showingAlert.toggle()
                    } else {
                        titleInput="Başarılı"
                        messageInput="Profil fotoğrafınız silinmiştir."
                        image=nil
                        profilPhoto=""
                        showingAlert.toggle()
                    }
                }
            }
        }
    }
    
    func uploadPhoto(){
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("Profile")
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
                                                  "StadiumName":infomodel.stadiumName] as [String:Any]
                                firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).setData(firestoreProfile) { (error) in
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


struct StadiumAccountView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumAccountView()
    }
}


