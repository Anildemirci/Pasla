//
//  PendingAppointmentsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import Firebase

struct PendingAppointmentsView: View {
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    @State var appointmentsArray=[String]()
    @State var daysArray=[String]()
    @State var selectedName=""
    
    var body: some View {
        VStack {
            if appointmentsArray.count == 0 {
                Text("Henüz bekleyen randevunuz yok.")
                    .font(.headline)
                    .foregroundColor(Color.black)
            } else {
                List(appointmentsArray,id:\.self){ appointments in
                    NavigationLink(destination: ConfirmAppointmentView(selectedName: selectedName, documentID: appointments).onAppear(){
                        
                    }){
                        Text(appointments)
                    }
                }
            }
        }.onAppear{
            getFromDatabase()
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
    
    func getFromDatabase(){
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
            daysArray.append(date)
        }
        
        firestoreDatabase.collection("StadiumAppointments").document(selectedName).collection(selectedName).whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                appointmentsArray.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let date=document.get("AppointmentDate") as! String
                    if self.daysArray.contains(date) {
                        self.appointmentsArray.append(document.documentID)
                    }
                }
                if self.appointmentsArray.count == 0 {
                    //tıklanmasın
                }
            }
        }
    }
}

struct PendingAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        PendingAppointmentsView()
    }
}
