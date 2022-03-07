//
//  CommentsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import Firebase
import Combine

struct CommentsView: View {
    
    var selectedStadium=""
    
    @StateObject var stadiuminfo=UsersInfoModel()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var body: some View {
        VStack{
            if stadiuminfo.stadiumId == currentUser!.uid {
                CommentForStadium(name:selectedStadium)
            } else if stadiuminfo.userId == currentUser!.uid {
                CommentForUser()
            }
        }.onAppear{
            stadiuminfo.getDataForStadium()
            stadiuminfo.getDataForUser()
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}

struct commentInfos : Identifiable {
    var id : String
    var comment : String
    var fullname : String
    var date : String
    var score : String
}

struct CommentForUser : View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @StateObject var stadiuminfo=UsersInfoModel()
    @State var commentsArrayStruct = [commentInfos]()
    @State var totalScore=Double()
    @State var score=""
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    
    var body: some View {
        VStack{
            if commentsArrayStruct.count == 0 {
                Text("Henüz yorum yapılmadı.")
            } else {
                Spacer()
                let roundedValue=NSString(format: "%.2f",totalScore)
                Text("\(commentsArrayStruct.count) müşteri oyu ile \(roundedValue) puan.")
                List(commentsArrayStruct){ i in
                    VStack{
                        HStack(alignment:.top){
                            VStack(alignment: .leading){
                                Text(i.fullname)
                                Text(i.date)
                            }
                            Spacer()
                            if i.score == "5-Çok iyi"{
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "4-İyi" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "3-Orta" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "2-Kötü" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "1- Çok kötü" {
                                Image(systemName: "star.fill").foregroundColor(Color.yellow)
                            }
                        }
                        Spacer()
                        Text(i.comment)
                    }
                }
            }
        }.onAppear{
            getComment()
        }
    }
    
    func getComment() {
        
        //stadiuminfo.getDataForStadium()
        var i=0
        firestoreDatabase.collection("Evaluation").document(chosenStadiumName).collection(chosenStadiumName).order(by: "CommentDate",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                //local hata
            } else {
                //anlık güncelleme gelince fazla veri göstermemesi için hafızada tutmuyor.
                commentsArrayStruct.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    let comments = document.get("Comment") as! String
                    let username = document.get("FullName") as! String
                    let commentDate = document.get("CommentDate") as! String
                    let scorePoint = document.get("Score") as! String
                    i=i+1
                        if scorePoint.contains("5-Çok iyi") {
                            totalScore=(totalScore+5.00)
                        } else if scorePoint.contains("4-İyi") {
                            totalScore=(totalScore+4.00)
                        } else if scorePoint.contains("3-Orta") {
                            totalScore=(totalScore+3.00)
                        } else if scorePoint.contains("2-Kötü") {
                            totalScore=(totalScore+2.00)
                        } else if scorePoint.contains("1-Çok kötü") {
                            totalScore=(totalScore+1.00)
                        }
                    commentsArrayStruct.append((commentInfos(id: document.documentID, comment: comments, fullname: username, date: commentDate, score: scorePoint)))
                }
                if i != 0 {
                    totalScore=totalScore/Double(i)
                } else {
                    totalScore=0.00
                }
                
                self.didChange.send(commentsArrayStruct)
            }
        }
        
    }
}

struct CommentForStadium : View {
    
    @StateObject var stadiuminfo=UsersInfoModel()
    @State var commentsArrayStruct = [commentInfos]()
    @State var name=""
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    @State var totalScore=Double()
    @State var score=""
    
    var body: some View {
        VStack{
            if commentsArrayStruct.count == 0 {
                Text("Henüz yorum yapılmadı.")
            } else {
                Spacer()
                let roundedValue=NSString(format: "%.2f",totalScore)
                Text("\(commentsArrayStruct.count) müşteri oyu ile \(roundedValue) puan.")
                List(commentsArrayStruct){ i in
                    VStack{
                        HStack(alignment:.top){
                            VStack(alignment: .leading){
                                Text(i.fullname)
                                Text(i.date)
                            }
                            Spacer()
                            if i.score == "5-Çok iyi"{
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "4-İyi" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "3-Orta" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "2-Kötü" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "1- Çok kötü" {
                                Image(systemName: "star.fill").foregroundColor(Color.yellow)
                            }
                        }
                        Spacer()
                        Text(i.comment)
                    }
                }
            }
        }.onAppear{
            getComment()
        }
    }
    func getComment() {
        
        stadiuminfo.getDataForStadium()
        var i=0;
        firestoreDatabase.collection("Evaluation").document(name).collection(name).order(by: "CommentDate",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                //local hata
            } else {
                //anlık güncelleme gelince fazla veri göstermemesi için hafızada tutmuyor.
                commentsArrayStruct.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let comments = document.get("Comment") as! String
                    let username = document.get("FullName") as! String
                    let commentDate = document.get("CommentDate") as! String
                    let scorePoint = document.get("Score") as! String
                    i=i+i
                        if score.contains("5-Çok iyi") {
                            totalScore=(totalScore+5.00)
                        } else if score.contains("4-İyi") {
                            totalScore=(totalScore+4.00)
                        } else if score.contains("3-Orta") {
                            totalScore=(totalScore+3.00)
                        } else if score.contains("2-Kötü") {
                            totalScore=(totalScore+2.00)
                        } else if score.contains("1-Çok kötü") {
                            totalScore=(totalScore+1.00)
                        }
                    commentsArrayStruct.append((commentInfos(id: document.documentID, comment: comments, fullname: username, date: commentDate, score: scorePoint)))
                }
                if i != 0 {
                    totalScore=totalScore/Double(i)
                } else {
                    totalScore=0.00
                }
                self.didChange.send(commentsArrayStruct)
            }
        }
        
    }
    
}

