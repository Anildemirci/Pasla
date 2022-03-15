//
//  StadiumPhotosView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct StadiumPhotosView: View {
    
    
    @State var chosenPhoto=""
    @State var userTypeArray=[String]()
    @State var stadiumTypeArray=[String]()
    @State var delStorage=""
    @State var shown=false
    @State var show=false
    @State var user=""
    @State var url=""
    @State var selection=Set<String>()
    @State var editMode: EditMode = .inactive
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    @StateObject var photosInfo=StadiumPhotosModel()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    var userType=""
    var selectedName=""
    
    var body: some View {
        
        if userType == "Stadium" {
            
                VStack{
                    if photosInfo.posts.isEmpty{
                        Text("Saha tarafından fotoğraf yüklenmedi henüz.").fontWeight(.heavy)
                    } else {
                        List {
                            ForEach(photosInfo.posts){ i in
                                photosStruct(statement: i.statement, image: i.image, id: i.id,show: $show,url: $url)
                            }.onDelete(perform: deletePhoto)
                        }
                    }
                }.navigationTitle(Text("Fotoğraflar")).navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Tamam")))
                }
            .onAppear{
                stadiumNamee=selectedName
                photosInfo.getDataForStadium()
            }
            .sheet(isPresented: $show){
                statusView(url: url)
            }.navigationBarItems(trailing:
                Button(action: {
                shown.toggle()
                }){
                    Image(systemName: "plus").resizable().frame(width: 30, height: 30)
                        .sheet(isPresented: $shown) { () -> UploadPhotos in
                            return UploadPhotos()
                        }
                }
            )
                .navigationBarItems(trailing:
                    Button(action: {
                    
                    }){
                        Image(systemName: "trash").resizable().frame(width: 30, height: 30)
                    }
                )
        } else {
             ScrollView(.vertical,showsIndicators: false){
                 VStack{
                     if  photosInfo.posts.isEmpty{
                         Text("Saha tarafından fotoğraf yüklenmedi henüz.").fontWeight(.heavy)
                     } else {
                         ForEach(photosInfo.posts){i in
                             photosStruct(statement: i.statement, image: i.image, id: i.id,show: $show,url: $url)
                         }
                         .animation(.spring())
                     }
                 }.navigationTitle(Text("Fotoğraflar")).navigationBarTitleDisplayMode(.inline)
             }.onAppear{
                 photosInfo.getDataForUser()
             }
             
        }
        
    }
    
    func deletePhoto(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let delPhoto=photosInfo.imageUrl[index]
            let delStorage=photosInfo.storageId[index]
            firestoreDatabase.collection("StadiumPhotos").document(stadiumNamee).collection("Photos").whereField("photoUrl", isEqualTo: delPhoto).getDocuments() { (query, error) in
                if error == nil {
                    for document in query!.documents{
                        let delDocID=document.documentID
                        firestoreDatabase.collection("StadiumPhotos").document(stadiumNamee).collection("Photos").document(delDocID).delete(){ error in
                            if error == nil {
                                storage.reference().child("StadiumPhotos").child(stadiumNamee).child("\(delStorage).jpg").delete { error in
                                    if error != nil {
                                        titleInput="Hata"
                                        messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        showingAlert.toggle()
                                    } else {
                                        titleInput="Başarılı"
                                        messageInput="Fotoğraf silindi."
                                        showingAlert.toggle()
                                    }
                                }
                            }else {
                                titleInput="Hata"
                                messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                showingAlert.toggle()
                            }
                        }
                    }
                }
            }
        }
    }

}


struct StadiumPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumPhotosView()
    }
}

struct photosStruct : View {
    
    var statement=""
    var image=""
    var id=""
    @Binding var show : Bool
    @Binding var url : String
    
    var body: some View {
        VStack{
            AnimatedImage(url: URL(string: image))
                .resizable().frame(width:350 ,height:350)
                .onTapGesture {
                    url=image
                    show.toggle()
                }
            HStack{
                Text(statement)
            }
        }.padding(8)
    }
}


struct dataType : Identifiable,Hashable {
    var id : String
    var statement : String
    var image : String
}


struct statusView:View{
    @State var url=""
    var body: some View{
        ZStack{
            AnimatedImage(url: URL(string: url)).resizable().edgesIgnoringSafeArea(.all)
        }
    }
}


