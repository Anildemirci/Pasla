//
//  StadiumCommentModel.swift
//  Pasla
//
//  Created by Anıl Demirci on 21.01.2022.
//

import SwiftUI
import Firebase

class StadiumCommentModel : ObservableObject {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    
    @Published var name=chosenStadiumName
    @Published var score=[String]()
    @Published var comment=[String]()
    @Published var date=[String]()
    @Published var commentArray=[String]()
    @Published var documentID=""
    @Published var userName=[String]()
    @Published var totalScore=Double()
    
    
    func getComment() {
        firestoreDatabase.collection("Evaluation").document(name).collection(name).order(by: "CommentDate",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                //local hata
            } else {
                //anlık güncelleme gelince fazla veri göstermemesi için hafızada tutmuyor.
                self.comment.removeAll(keepingCapacity: false)
                self.score.removeAll(keepingCapacity: false)
                self.date.removeAll(keepingCapacity: false)
                self.userName.removeAll(keepingCapacity: false)
                self.commentArray.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    self.commentArray.append(document.documentID)
                    if let comments = document.get("Comment") as? String {
                        self.comment.append(comments)
                    }
                    if let username = document.get("FullName") as? String {
                        self.userName.append(username)
                    }
                    if let commentDate = document.get("CommentDate") as? String {
                        self.date.append(commentDate)
                    }
                    if let scorePoint = document.get("Score") as? String {
                        self.score.append(scorePoint)
                        if self.score.contains("5-Çok iyi") {
                            self.totalScore=self.totalScore+5
                        } else if self.score.contains("4-İyi") {
                            self.totalScore=self.totalScore+4
                        } else if self.score.contains("3-Orta") {
                            self.totalScore=self.totalScore+3
                        } else if self.score.contains("2-Kötü") {
                            self.totalScore=self.totalScore+2
                        } else if self.score.contains("1-Çok kötü") {
                            self.totalScore=self.totalScore+1
                        }
                    }
                }
            }
        }
        
    }
    
}
