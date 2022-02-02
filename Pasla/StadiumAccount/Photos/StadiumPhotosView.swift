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

    @StateObject var photosInfo=StadiumPhotosModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    var userType=""
    var selectedName=""
    
    var body: some View {
        
        if userType == "Stadium" {
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    if photosInfo.posts.isEmpty{
                        Text("Saha tarafından fotoğraf yüklenmedi henüz.").fontWeight(.heavy)
                    } else {
                        ForEach(photosInfo.posts){i in
                            photosStruct(statement: i.statement, image: i.image, id: i.id,show: $show,url: $url)
                        }.animation(.spring())
                    }
                }
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
        } else {
             ScrollView(.vertical,showsIndicators: false){
                 VStack{
                     if  photosInfo.posts.isEmpty{
                         Text("Saha tarafından fotoğraf yüklenmedi henüz.").fontWeight(.heavy)
                     } else {
                         ForEach(photosInfo.posts){i in
                             photosStruct(statement: i.statement, image: i.image, id: i.id,show: $show,url: $url)
                         }.animation(.spring())
                     }
                 }
             }.onAppear{
                 //favorilerden tıklarsa hata veriyor düzelt.
                 photosInfo.getDataForUser()
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
                .resizable().frame(width:350,height:350)
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


struct dataType : Identifiable {
    var id : String
    var statement : String
    var image : String
}

struct statusView:View{
    var url=""
    var body: some View{
        ZStack{
            AnimatedImage(url: URL(string: url)).resizable().edgesIgnoringSafeArea(.all)
        }
    }
}
