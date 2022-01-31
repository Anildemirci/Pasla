//
//  ConfirmDateView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct ConfirmDateView: View {
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @StateObject var daysInfo=dayArrayForStadium()
    
    @State var selectedField=""
    @State var shown=false
    @State var chosenDay=""
    @State var preDay=""
    @State var yellowDates=[String]()
    @State var redDates=[String]()
    @State var redHours=[String]()
    @State var yellowHours=[String]()
    @State var closedByStadium=[String]()
    @State var stadiumName=""
    @State var selection=Set<String>()
    //@State var selection: String?
    @State var editMode: EditMode = .inactive
    @State var isEditing=false
    @State var isOpening=false
    @State var isClosing=false
    @State var selectedMenu=""
    
    @State var
    hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
    
    @State var messageInput=""
    @State var titleInput=""
    @State var shownAlert=false
    
    
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
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.red)
                    Text("Müsait").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.green)
                        //.border(Color.black, width: 2)
                }
                HStack{
                    Text("Onay Bekliyor").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.yellow)
                    Text("Saha tarafından kapatıldı").scaledToFill()
                        //.padding()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.purple)
                }
            }
            Spacer()
            if chosenDay=="" {
                VStack {
                    Text("Lütfen tarih seçiniz.")
                }
            } else {
                List(hourArray,id:\.self,selection: $selection){ hour in
                        Button(action: {
                        
                        }, label: {
                            Text(hour)
                                .frame(width: UIScreen.main.bounds.width * 0.7)
                                .padding()
                                .background(yellowDates.contains(hour) ? Color.yellow: redDates.contains(hour) ? Color.red: closedByStadium.contains(hour) ? Color.purple: .green)
                                .foregroundColor(.black)
                        })
                        .disabled(yellowDates.contains(hour) ? true: redDates.contains(hour) ? true: closedByStadium.contains(hour) ? true: false)
                }.onAppear{
                    print($selection)
                    print(selection)
                }.environment(\.editMode, $editMode)
            }
            Spacer()
                .frame(height: 10.0)
            VStack{
                if selection.isEmpty == false {
                    if selectedMenu=="close" {
                        HStack{
                            Button(action: {
                                closeClicked(hour: [String](selection))
                                isClosing=false
                                editMode=isClosing ? .active : .inactive
                                if editMode == .inactive {
                                    selection.removeAll(keepingCapacity: false)
                                    selectedMenu=""
                                    //chosenDay=""
                                }
                            }) {
                                Text("Kapat")
                            }.frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05).background(Color.red).foregroundColor(Color.white)
                            Button(action: {
                                isClosing=false
                                selection.removeAll(keepingCapacity: false)
                                selectedMenu=""
                                editMode=isClosing ? .active : .inactive
                            }) {
                                Text("İptal")
                            }.frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05).background(Color.yellow).foregroundColor(Color.white)
                        }.padding()
                    } else if selectedMenu=="open" {
                        HStack{
                            Button(action: {
                                openClicked(hour: [String](selection))
                                isOpening=false
                                editMode=isOpening ? .active : .inactive
                                if editMode == .inactive {
                                    selection.removeAll(keepingCapacity: false)
                                    selectedMenu=""
                                    chosenDay=""
                                }
                            }) {
                                Text("Aç")
                            }.frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05).background(Color.green).foregroundColor(Color.white)
                            Button(action: {
                                isOpening=false
                                editMode=isOpening ? .active : .inactive
                                selection.removeAll(keepingCapacity: false)
                                selectedMenu=""
                            }) {
                                Text("İptal")
                            }.frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05).background(Color.yellow).foregroundColor(Color.white)
                        }.padding()
                    }
                } else {
                    if selectedMenu=="open" || selectedMenu=="close" {
                        Button(action: {
                            isOpening=false
                            isClosing=false
                            editMode=isOpening ? .active : .inactive
                            editMode=isClosing ? .active : .inactive
                            selection.removeAll(keepingCapacity: false)
                            selectedMenu=""
                        }) {
                            Text("İptal")
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 100.0, height: 50.0)
                    }
                }
            }
            Spacer()
        }.onAppear{
            daysInfo.days()
        }
        .alert(isPresented: $shownAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Tamam")))
        }
        .navigationTitle(Text("Tarih ve Saat Seçimi"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if chosenDay != "" {
                    Menu {
                        Button(action: {
                            selectedMenu="close"
                            if isClosing==false {
                                isClosing=true
                                isOpening=false
                            } else {
                                isClosing=false
                            }
                            editMode=isClosing ? .active : .inactive
                            if editMode == .inactive {
                                selection.removeAll(keepingCapacity: false)
                                selectedMenu=""
                            }
                            
                        }) {
                            Text("Saati kapat")
                        }
                        Button(action: {
                            selectedMenu="open"
                            if isOpening==false {
                                isOpening=true
                                isClosing=false
                            } else {
                                isOpening=false
                            }
                            editMode=isOpening ? .active : .inactive
                            if editMode == .inactive {
                                selection.removeAll(keepingCapacity: false)
                                selectedMenu=""
                            }
                        }) {
                            Text("Saati aç")
                        }
                        Button(action: {
                            isEditing.toggle()
                            editMode=isEditing ? .active : .inactive
                            
                        }) {
                            Text("Fiyat gir")
                        }
                    } label: {
                        Label(
                            title: {Text("edit")},
                            icon: {Image(systemName: "square.and.pencil") }
                        )
                    }
                } else {
                    
                }
            }
        }
    }
    
    func getDatefromCalendar(day: String){
        if preDay != day {
            redDates.removeAll(keepingCapacity: false)
            yellowDates.removeAll(keepingCapacity: false)
            closedByStadium.removeAll(keepingCapacity: false)
            self.firestoreDatabase.collection("Calendar").document(stadiumName).collection(selectedField).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let type=document.get("Type") {
                            if type as! String == "Stadium" {
                                let closedStadium=document.get("Hour") as! String
                                if self.closedByStadium.contains(closedStadium) {
                                    //içeriyor ekleme.
                                } else {
                                    self.closedByStadium.append(closedStadium)
                                }
                            } else if type as! String == "User" {
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
                }
            }
        } else {
            self.firestoreDatabase.collection("Calendar").document(stadiumName).collection(selectedField).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let type=document.get("Type") {
                            if type as! String == "Stadium" {
                                let closedStadium=document.get("Hour") as! String
                                if self.closedByStadium.contains(closedStadium) {
                                    
                                } else {
                                    self.closedByStadium.append(closedStadium)
                                }
                            } else if type as! String == "User" {
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
                }
            }
        }
    }
    
    func closeClicked(hour: [String]){
        if hour.isEmpty {
            titleInput="Hata"
            messageInput="Saat seçilmedi."
            shownAlert.toggle()
        } else {
            for selectHour in hour {
                if yellowDates.contains(selectHour) || redDates.contains(selectHour) {
                    titleInput="Uyarı"
                    messageInput="Onaylanan ya da bekleyen randevuları kapatamazsınız!"
                    shownAlert.toggle()
                } else {
                    let firestoreCalendar=["User":Auth.auth().currentUser!.uid,
                                           "Email":Auth.auth().currentUser!.email!,
                                           "Type":"Stadium",
                                           "StadiumName":stadiumName,
                                           "FieldName":selectedField,
                                           "Hour":selectHour,
                                           "AppointmentDate":chosenDay,
                                           "Price":"Bilinmiyor.",
                                           "Status":"Onaylandı.",
                                           "Date":FieldValue.serverTimestamp()] as [String:Any]
                    self.firestoreDatabase.collection("Calendar").document(stadiumName).collection(selectedField).document(chosenDay+"-"+selectHour).setData(firestoreCalendar) {
                        error in
                        if error != nil {
                            titleInput="Hata"
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            shownAlert.toggle()
                        }
                        else {
                            //başarılı Seçtiğiniz saatleri randevulara kapattınız.
                            //hour=""
                        }
                    }
                }
            }
        }
    }
    func openClicked(hour: [String]){
        if hour.isEmpty {
            titleInput="Hata"
            messageInput="Saat seçilmedi."
            shownAlert.toggle()
        } else {
            for selectHour in hour {
                if yellowDates.contains(selectHour) || redDates.contains(selectHour) {
                    titleInput="Uyarı"
                    messageInput="Onaylanan ya da bekleyen randevuları açamazsınız!"
                    shownAlert.toggle()
                } else {
                    self.firestoreDatabase.collection("Calendar").document(stadiumName).collection(selectedField).document(chosenDay+"-"+selectHour).delete {
                        error in
                        if error != nil {
                            titleInput="Hata"
                            messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            shownAlert.toggle()
                        }
                        else {
                            titleInput="Başarılı"
                            messageInput="Seçtiğiniz saatleri randevulara açtınız."
                            shownAlert.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct ConfirmDateView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmDateView()
    }
}

class dayArrayForStadium:ObservableObject{
    
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

