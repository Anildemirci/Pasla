//
//  UsersInfoModel.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.01.2022.
//

import SwiftUI
import Firebase
import Combine

class UsersInfoModel:ObservableObject{
    
    @Published var stadiumInfos = [String]()
    @Published var stadiumAddress=""
    @Published var stadiumOpen=""
    @Published var stadiumClose=""
    @Published var stadiumCity=""
    @Published var stadiumEmail=""
    @Published var stadiumName=""
    @Published var stadiumNumberOfField=""
    @Published var stadiumPhone=""
    @Published var stadiumTown=""
    @Published var stadiumType=""
    @Published var stadiumId=""
    @Published var userCity=""
    @Published var userEmail=""
    @Published var userName=""
    @Published var userSurname=""
    @Published var userPhone=""
    @Published var userTown=""
    @Published var userType=""
    @Published var userId=""
    @Published var userBirthday=""
    @Published var userFavStadium=[String]()
    @Published var intNumberField=0
    @Published var nameFields=[String]()
    @Published var workingHour=[String]()
    @Published var workingHour2=[String]()
    @Published var daysArray=[String]()
    @Published var appointmentsArray=[String]()
    
    func getDataForUser(){
        let db=Firestore.firestore()
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
    
                if let city=snapshot?.get("City") as? String {
                    self.userCity=city
                }
                if let email=snapshot?.get("Email") as? String {
                    self.userEmail=email
                }
                if let name=snapshot?.get("Name") as? String {
                    self.userName=name
                }
                if let surname=snapshot?.get("Surname") as? String {
                    self.userSurname=surname
                }
                if let phonenumber=snapshot?.get("Phone") as? String {
                    self.userPhone=phonenumber
                }
                if let town=snapshot?.get("Town") as? String {
                    self.userTown=town
                }
                if let type=snapshot?.get("Type") as? String {
                    self.userType=type
                }
                if let id=snapshot?.get("User") as? String {
                    self.userId=id
                }
                if let birthday=snapshot?.get("DateofBirth") as? String {
                    self.userBirthday=birthday
                }
                if let favStadiums=snapshot?.get("FavoriteStadiums") as? [String]{
                    self.userFavStadium=favStadiums
                }
            }
        }
    }
    
    func getDataForStadium(){
        let db=Firestore.firestore()
        db.collection("Stadiums").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                if let address=snapshot?.get("Address") as? String {
                    self.stadiumAddress=address
                }
                if let openTime=snapshot?.get("Opened") as? String {
                    self.stadiumOpen=openTime
                }
                if let closeTime=snapshot?.get("Closed") as? String {
                    self.stadiumClose=closeTime
                }
                if let info=snapshot?.get("Informations") as? [String] {
                    self.stadiumInfos=info
                }
                if let city=snapshot?.get("City") as? String {
                    self.stadiumCity=city
                }
                if let email=snapshot?.get("Email") as? String {
                    self.stadiumEmail=email
                }
                if let name=snapshot?.get("Name") as? String {
                    self.stadiumName=name
                }
                if let workinghour=snapshot?.get("WorkingHour") as? [String] {
                    self.workingHour=workinghour
                }
                if let workinghour2=snapshot?.get("WorkingHour2") as? [String] {
                    self.workingHour2=workinghour2
                }
                if let numberField=snapshot?.get("NumberOfField") as? String {
                    self.stadiumNumberOfField=numberField
                    self.intNumberField=Int(numberField)! //numara girmezse hata alıyor
                    self.nameFields.removeAll(keepingCapacity: false)
                    for number in 1...self.intNumberField {
                        self.nameFields.append("Saha \(number)")
                    }
                }
                if let phonenumber=snapshot?.get("Phone") as? String {
                    self.stadiumPhone=phonenumber
                }
                if let town=snapshot?.get("Town") as? String {
                    self.stadiumTown=town
                }
                if let type=snapshot?.get("Type") as? String {
                    self.stadiumType=type
                }
                if let id=snapshot?.get("User") as? String {
                    self.stadiumId=id
                }
            }
        }
    }
    
    func getCurrentDate()->Date {
        var now=Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now
    }

    func getAppointment() {
        
       getDataForStadium()
        
        for day in 0...13 {
            let hourToAdd=0 //tr saatlerine göre +2 ekle
            let daysToAdd=0 + day
            let UTCDate = getCurrentDate()
            var dateComponent = DateComponents()
            dateComponent.hour=hourToAdd
            dateComponent.day = daysToAdd
            let currentDate = Calendar.current.date(byAdding: dateComponent, to: UTCDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.string(from: currentDate! as Date)
            self.daysArray.append(date)
        }
        let db=Firestore.firestore()
        db.collection("StadiumAppointments").document("Biral").collection("Biral").whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.appointmentsArray.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let date=document.get("AppointmentDate") as! String
                    if self.daysArray.contains(date) {
                        self.appointmentsArray.append(document.documentID)
                    }
                }
            }
        }

    }

    
}

