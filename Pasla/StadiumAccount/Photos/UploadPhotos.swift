//
//  UploadPhotos.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import AVFoundation
import Firebase

struct UploadPhotos: View {
    
    @State var statementText=""
    @State var isShowPhotoLibrary=false
    @State var image=UIImage()
    @State var isShowCamera=false
    @State var shown=false
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    @State var uuid=""
    @StateObject var stadiumInfo=UsersInfoModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    
    var body: some View {
        VStack{
            if let image = image {
                Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 0, maxWidth: .infinity,maxHeight: UIScreen.main.bounds.width * 1)
                                .padding(.horizontal)
            } else {
                Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.horizontal)
            }
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 20))
                                Text("Fotoğraflar")
                                    .font(.headline)
                            }
                            //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .frame(width: 300, height: 60 )
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                        }
            Button(action: {
                self.isShowCamera = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                    Text("Kamera")
                        .font(.headline)
                }
                //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .frame(width: 300, height: 60 )
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.horizontal)
            }
            Spacer()
            TextField("Açıklama", text: $statementText)
                            .padding()
                        Spacer()
                        Button(action: {
                            uploadPhoto()
                        }) {
                            Text("Yükle")
                                //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                                .frame(width: 300, height: 60 )
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .padding(.horizontal)
                                .fullScreenCover(isPresented: $shown) { () -> StadiumPhotosView in
                                    return StadiumPhotosView()
                                }
                        }
            Spacer()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func uploadPhoto(){
        stadiumInfo.getDataForStadium()
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("StadiumPhotos").child(stadiumInfo.stadiumName)
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
                            
                            var firestoreReference:DocumentReference?=nil
                            let firestorePhotos=["photoUrl":imageUrl!,
                                                 "ID":currentUser!.uid,
                                                 "User":currentUser!.email!,
                                                 "Date":FieldValue.serverTimestamp(),
                                                 "Statement":statementText,
                                                 "Name":stadiumInfo.stadiumName,
                                                 "StorageID":self.uuid] as [String:Any]
                            firestoreReference=self.firestoreDatabase.collection("StadiumPhotos").document(stadiumInfo.stadiumName).collection("Photos").addDocument(data: firestorePhotos) { (error) in
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


struct UploadPhotos_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotos()
    }
}
