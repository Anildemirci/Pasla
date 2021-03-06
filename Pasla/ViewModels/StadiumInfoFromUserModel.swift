//
//  StadiumInfoFromUserModel.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.01.2022.
//

import SwiftUI
import Firebase

class StadiumInfoFromUserModel : ObservableObject {
    
    @Published var infos = [String]()
    @Published var address=""
    @Published var open=""
    @Published var close=""
    @Published var city=""
    @Published var email=""
    @Published var name=""
    @Published var numberOfField=""
    @Published var phone=""
    @Published var town=""
    @Published var type=""
    @Published var id=""
    @Published var intNumberField=0
    @Published var nameFields=[String]()
    @Published var workingHour=[String]()
    @Published var workingHour2=[String]()
    @Published var annotationLatitude=Double()
    @Published var annotationLongitude=Double()
    
    init(){
        let db=Firestore.firestore()
        db.collection("Stadiums").whereField("Town", isEqualTo: chosenTown).addSnapshotListener { (snapshot, error) in
            if error == nil {
                
                for document in snapshot!.documents {
                    if let address=document.get("Address") as? String {
                        self.address=address
                    }
                    if let openTime=document.get("Opened") as? String {
                        self.open=openTime
                    }
                    if let closeTime=document.get("Closed") as? String {
                        self.close=closeTime
                    }
                    if let info=document.get("Informations") as? [String] {
                        self.infos=info
                    }
                    if let city=document.get("City") as? String {
                        self.city=city
                    }
                    if let email=document.get("Email") as? String {
                        self.email=email
                    }
                    if let name=document.get("Name") as? String {
                        self.name=name
                    }
                    if let numberField=document.get("NumberOfField") as? String {
                        self.numberOfField=numberField
                    }
                    if let phonenumber=document.get("Phone") as? String {
                        self.phone=phonenumber
                    }
                    if let town=document.get("Town") as? String {
                        self.town=town
                    }
                    if let type=document.get("Type") as? String {
                        self.type=type
                    }
                    if let id=document.get("User") as? String {
                        self.id=id
                    }
                }
                
            }
        }
    }
    
    func getDataFromInfoForUser(){
        let db=Firestore.firestore()
        db.collection("Stadiums").whereField("Name", isEqualTo: chosenStadiumName).getDocuments { (snapshot, error) in
            if error == nil {
                
                for document in snapshot!.documents {
                    if let address=document.get("Address") as? String {
                        self.address=address
                    }
                    if let openTime=document.get("Opened") as? String {
                        self.open=openTime
                    }
                    if let closeTime=document.get("Closed") as? String {
                        self.close=closeTime
                    }
                    if let info=document.get("Informations") as? [String] {
                        self.infos=info
                    }
                    if let city=document.get("City") as? String {
                        self.city=city
                    }
                    if let email=document.get("Email") as? String {
                        self.email=email
                    }
                    if let name=document.get("Name") as? String {
                        self.name=name
                    }
                    if let workinghour=document.get("WorkingHour") as? [String] {
                        self.workingHour=workinghour
                    }
                    if let workinghour2=document.get("WorkingHour2") as? [String] {
                        self.workingHour2=workinghour2
                    }
                    if let numberField=document.get("NumberOfField") as? String {
                        self.numberOfField=numberField
                        self.intNumberField=Int(numberField)!
                        self.nameFields.removeAll(keepingCapacity: false)
                        for number in 1...self.intNumberField {
                            self.nameFields.append("Saha \(number)")
                        }
                    }
                    if let phonenumber=document.get("Phone") as? String {
                        self.phone=phonenumber
                    }
                    if let town=document.get("Town") as? String {
                        self.town=town
                    }
                    if let type=document.get("Type") as? String {
                        self.type=type
                    }
                    if let id=document.get("User") as? String {
                        self.id=id
                    }
                }
                
            }
        }
    }
    
    func getLocation(){
        let db=Firestore.firestore()
        db.collection("Locations").whereField("StadiumName", isEqualTo: chosenStadiumName).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let documentId=document.documentID
                    db.collection("Locations").document(documentId).addSnapshotListener { (snapshot, error) in
                        if error == nil {
                            
                            if let longitude=snapshot?.get("Longitude") {
                                self.annotationLongitude=longitude as! Double
                            } else  {
                                self.annotationLongitude=0
                            }
                            if let latitude=snapshot?.get("Latitude") {
                                self.annotationLatitude=latitude as! Double
                            } else {
                                self.annotationLatitude=0
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
}
