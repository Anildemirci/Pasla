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
    
    @State var image=""
    @State var chosenPhoto=""
    @State var userTypeArray=[String]()
    @State var stadiumTypeArray=[String]()
    @State var ID=""
    @State var delStorage=""
    @State var shown=false
    
    @ObservedObject var photosObserver = photoObserver()
    @State var show=false
    @State var user=""
    @State var url=""
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    
    var body: some View {
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    if photosObserver.posts.isEmpty{
                        Text("Saha tarafından fotoğraf yüklenmedi henüz.").fontWeight(.heavy)
                    } else {
                        ForEach(photosObserver.posts){i in
                            photosStruct(statement: i.statement, image: i.image, id: i.id,show: $show,url: $url)
                        }.animation(.spring())
                    }
                }
            }.sheet(isPresented: $show){
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

class photoObserver : ObservableObject {
    
    @Published var posts = [dataType]()
    var photoStatement=[String]()
    var storageId=[String]()
    var imageUrl=[String]()
    
    init(){
        let db=Firestore.firestore()
        let currentUser=Auth.auth().currentUser
        db.collection("StadiumPhotos").document(currentUser!.uid).collection("Photos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            } else {
                
                self.photoStatement.removeAll(keepingCapacity: false)
                self.imageUrl.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents{
                    let documentID=document.documentID
                    let statement=document.get("Statement") as! String
                    let image=document.get("photoUrl") as! String
                    
                    self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                }
            }
        }
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
