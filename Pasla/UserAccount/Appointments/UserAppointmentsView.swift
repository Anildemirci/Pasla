//
//  UserAppointmentsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct UserAppointmentsView: View {
    
    @State var appointmentsArray=[String]()
    @State var confirmedAppointmentsArray=[String]()
    @State var pastAppointments=[String]()
    @State var status=""
    @State var daysArray=[String]()
    @State var appointmentCount=0
    @State var today=""
    @State var number=0
    @State var shown=false
    @State var findStadium=false
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    
    var body: some View {
        VStack{
            if status == "Onaylandı." {
                if today == "past" {
                    if pastAppointments.count != 0{
                        List(pastAppointments,id:\.self){ past in
                            NavigationLink(destination: EvaluationView(documentID:past,status:status).onAppear(){
                                
                            }){
                                Text(past)
                            }
                        }
                    } else {
                        Text("Geçmiş randevunuz bulunmamaktadır.")
                        Text("İstanbul'da sana uygun sahalara bakmak ister misin?")
                        Button(action: {
                            findStadium.toggle()
                            selectionTab=2
                        }){
                            Text("Saha bul")
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .clipShape(Capsule())
                                .fullScreenCover(isPresented: $findStadium) { () -> UserAccountView in
                                    return UserAccountView()
                                }
                        }
                    }
                } else if today == "next" {
                    if confirmedAppointmentsArray.count != 0 {
                        List(confirmedAppointmentsArray,id:\.self){ confirmed in
                            NavigationLink(destination: EvaluationView(documentID:confirmed,status:status).onAppear(){
                                
                            }){
                                Text(confirmed)
                            }
                        }
                    } else {
                        Text("Onaylanan randevunuz bulunmamaktadır.")
                        Text("İstanbul'da sana uygun sahalara bakmak ister misin?")
                        Button(action: {
                            findStadium.toggle()
                            selectionTab=2
                        }){
                            Text("Saha bul")
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .clipShape(Capsule())
                                .fullScreenCover(isPresented: $findStadium) { () -> UserAccountView in
                                    return UserAccountView()
                                }
                        }
                    }
                }
            } else {
                if appointmentsArray.count != 0 {
                    List(appointmentsArray,id:\.self){ appointments in
                        NavigationLink(destination: EvaluationView(documentID:appointments,status:status).onAppear(){
                            
                        }){
                            Text(appointments)
                        }
                    }
                } else {
                    Text("Bekleyen randevunuz bulunmamaktadır.")
                    Text("İstanbul'da sana uygun sahalara bakmak ister misin?")
                    Button(action: {
                        findStadium.toggle()
                        selectionTab=2
                    }){
                        Text("Saha bul")
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                            .fullScreenCover(isPresented: $findStadium) { () -> UserAccountView in
                                return UserAccountView()
                            }
                    }
                }
            }
        }.onAppear{
            getAppointments()
        }
    }
    
    
    func getAppointments(){
        for day in 0...13 {
            let hourToAdd=0
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
            daysArray.append(date)
        }
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo: status).addSnapshotListener { (snapshot, error) in
            if error == nil {
                appointmentsArray.removeAll(keepingCapacity: false)
                confirmedAppointmentsArray.removeAll(keepingCapacity: false)
                pastAppointments.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let date=document.get("AppointmentDate") as! String
                    if self.status == "Onay bekliyor." {
                        if self.daysArray.contains(date) {
                            self.appointmentsArray.append(document.documentID)
                        }
                    }
                    else if self.status == "Onaylandı." {
                        if self.daysArray.contains(date) {
                            self.confirmedAppointmentsArray.append(document.documentID)
                        } else {
                            self.pastAppointments.append(document.documentID)
                        }
                    }
                }
                if self.status == "Onay bekliyor." {
                    self.appointmentCount=self.appointmentsArray.count
                } else {
                    if self.today == "past" {
                        self.appointmentCount=self.pastAppointments.count
                    } else {
                        self.appointmentCount=self.confirmedAppointmentsArray.count
                    }
                }
                if self.appointmentCount == 0  {
                    //tıklanmasın
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
}

var selectionTab=0

struct UserAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        UserAppointmentsView()
    }
}

