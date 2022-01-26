//
//  StadiumPhotosModel.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.01.2022.
//

import SwiftUI
import Firebase
import Combine

class StadiumPhotosModel : ObservableObject {
    
    @Published var posts = [dataType]()
    @Published var photoStatement=[String]()
    @Published var storageId=[String]()
    @Published var imageUrl=[String]()
    var stinfo=UsersInfoModel()
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    
    func getDataForStadium(){
        let db=Firestore.firestore()
        db.collection("StadiumPhotos").document(stadiumNamee).collection("Photos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            } else {
                
                self.photoStatement.removeAll(keepingCapacity: false)
                self.imageUrl.removeAll(keepingCapacity: false)
                self.posts.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents{
                    let documentID=document.documentID
                    let statement=document.get("Statement") as! String
                    let image=document.get("photoUrl") as! String
                    
                    self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                }
                self.didChange.send(self.posts)
            }
        }
    }
    
    func getDataForUser(){
        let db=Firestore.firestore()
        db.collection("StadiumPhotos").document(chosenStadiumName).collection("Photos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            } else {
                
                self.photoStatement.removeAll(keepingCapacity: false)
                self.imageUrl.removeAll(keepingCapacity: false)
                self.posts.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents{
                    let documentID=document.documentID
                    let statement=document.get("Statement") as! String
                    let image=document.get("photoUrl") as! String
                    
                    self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                }
                self.didChange.send(self.posts)
            }
        }
    }
}
