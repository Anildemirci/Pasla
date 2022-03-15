//
//  DateView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase
import Combine

struct DateView: View {
    @StateObject var stadiuminfo=StadiumInfoFromUserModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @StateObject var daysInfo=dayArrayForUser()
    @State var chosenDay=""
    @State var preDay=""
    @State var yellowDates=[String]()
    @State var redDates=[String]()
    @State var redHours=[String]()
    @State var yellowHours=[String]()
    @State var selectedField=""
    @State var shown=false
    @State var hourType="Full"
    @State var checkInfos=false
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    
    var body: some View {
        VStack{
            Group{
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        ForEach(daysInfo.daysArray,id:\.self){day in
                            Button(action: {
                                chosenDay=day
                                getDatefromCalendar(day: chosenDay)
                            }, label:{
                                    Text(day)
                                    .padding()
                                    .foregroundColor(.black)
                                    .border(Color.black, width: 2)
                                    .background(chosenDay==day ? Color.red: .white)
                                })
                        }
                    }.padding()
                }
            }
            VStack {
                HStack{
                    Text("Müsait değil").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.red)
                    Text("Müsait").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.green)
                        //.border(Color.black, width: 2)
                    Text("Onay Bekliyor").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.yellow)
                }
            }
            Spacer()
            if chosenDay=="" {
                VStack {
                    Text("Lütfen tarih seçiniz.")
                }
            } else {
                List(hourType=="Full" ? stadiuminfo.workingHour: stadiuminfo.workingHour2,id:\.self){ hour in
                    NavigationLink(destination: RequestAppointmentView(numberField: selectedField, selectedDate: chosenDay, selectedHour: hour)){
                        Button(action: {
                           
                        }, label: {
                            Text(hour)
                                .frame(width: UIScreen.main.bounds.width * 0.7)
                                .padding()
                                .background(redDates.contains(hour) ? Color.red: yellowDates.contains(hour) ? Color.yellow: .green)
                                .foregroundColor(.black)
                        })
                    }.disabled(yellowDates.contains(hour) ? true: redDates.contains(hour) ? true: false)
                }
            }
            Spacer()
        }.onAppear{
            daysInfo.days()
            stadiuminfo.getDataFromInfoForUser()
            checkInfo()
            getDatefromCalendar(day: chosenDay)
        }
        .navigationTitle(Text("Tarih ve Saat Seçimi")).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                shown.toggle()
                })
                                {
                Image(systemName: "info.circle.fill").resizable().frame(width: 30, height: 30)
                    .sheet(isPresented: $shown) { () -> FieldInformationsView in
                        return FieldInformationsView(fieldname:selectedField)
                    }
            }
            )
    }
    
    func getInfos(){
        let fb=Firestore.firestore()
        
        fb.collection("FieldInformations").document(chosenStadiumName).collection("Fields").document(selectedField).addSnapshotListener { (document, error) in
            if error == nil {
                if let hourtype=document?.get("HourType") as? String {
                    hourType=hourtype
                }
                //fiyat ve kaporaları çekip listede gösterebilirsin
            }
        }
    }
    
    func checkInfo(){
        let fb=Firestore.firestore()
        
        fb.collection("FieldInformations").document(chosenStadiumName).collection("Fields").addSnapshotListener { (snapshot, error) in
            if error == nil {
                if snapshot?.isEmpty == true {
                    checkInfos=false
                } else {
                    for document in snapshot!.documents {
                        if document.documentID==selectedField {
                            checkInfos=true
                            getInfos()
                        }
                    }
                }
                
            }
        }
    }
    
    func getDatefromCalendar(day: String){
        
        if preDay != day {
            redDates.removeAll()
            yellowDates.removeAll()
            self.firestoreDatabase.collection("Calendar").document(chosenStadiumName).collection(selectedField).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let status=document.get("Status") {
                            if status as! String == "Onaylandı." {
                                let redhours=document.get("Hour")
                                if self.redDates.contains(redhours as! String) {
                                } else {
                                    self.redDates.append(redhours as! String)
                                }
                            }
                            else if status as! String == "Onay bekliyor." {
                                let yellowhours=document.get("Hour")
                                if self.yellowDates.contains(yellowhours as! String) {
                                } else {
                                    self.yellowDates.append(yellowhours as! String)
                                }
                            }
                        }
                    }
                }
            }
            self.didChange.send(redDates)
            self.didChange.send(yellowDates)
        } else {
            redDates.removeAll()
            yellowDates.removeAll()
            self.firestoreDatabase.collection("Calendar").document(chosenStadiumName).collection(selectedField).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let status=document.get("Status") {
                            if status as! String == "Onaylandı." {
                                let redhours=document.get("Hour")
                                if self.redDates.contains(redhours as! String) {
                                } else {
                                    self.redDates.append(redhours as! String)
                                }
                            }
                            else if status as! String == "Onay bekliyor." {
                                let yellowhours=document.get("Hour")
                                if self.yellowDates.contains(yellowhours as! String) {
                                } else {
                                    self.yellowDates.append(yellowhours as! String)
                                }
                            }
                        }
                    }
                }
            }
            self.didChange.send(redDates)
            self.didChange.send(yellowDates)
        }
    }
    
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView()
    }
}

class dayArrayForUser:ObservableObject{
    
    @Published var daysArray=[String]()
    
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
    
    func days(){
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
            self.daysArray.append(date)
        }
    }
}
