//
//  WorkingHours.swift
//  Pasla
//
//  Created by Anıl Demirci on 12.02.2022.
//

import SwiftUI
import Firebase

struct WorkingHours: View {
    
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    @State var isToogleOn=false
    @State var selection=Set<String>()
    @State var selection2=Set<String>()
    @State var editMode: EditMode = .inactive
    @State var workingHour=[String]()
    @State var saveButton=false
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
   
    var hourArray2=["00:30-01:30","01:30-02:30","02:30-03:30","03:30-04:30","04:30-05:30","05:30-06:30","06:30-07:30","07:30-08:30","08:30-09:30","09:30-10:30","10:30-11:30","11:30-12:30","12:30-13:30","13:30-14:30","14:30-15:30","15:30-16:30","16:30-17:30","17:30-18:30","18:30-19:30","19:30-20:30","20:30-21:30","21:30-22:30","22:30-23:30","23:30-00:30"]
    
    var body: some View {
        VStack{
            Text("Günlük Çalışma Saatleri").font(.largeTitle)
            Text("Açık olduğunuz saatleri işaretleyin").font(.footnote)
            
            Toggle(isOn: $isToogleOn,
                   label: {
                Text("Buçuklu saatler")
            }).toggleStyle(SwitchToggleStyle(tint: Color.green)).padding(.horizontal,100)
            
            if editMode == .active {
                Button(action: {
                    saveButton.toggle()
                    editMode = .inactive
                    selection.removeAll(keepingCapacity: false)
                    selection2.removeAll(keepingCapacity: false)
                }) {
                    Text("İptal")
                }
            }else {
                Button(action: {
                    saveButton.toggle()
                    editMode = .active
                }) {
                    Text("Düzenle")
                }
            }
            
            if isToogleOn==true {
                List(hourArray2,id:\.self,selection: $selection2){ hour in
                    Text(hour)
                }.environment(\.editMode, $editMode)
            } else {
                List(hourArray,id:\.self,selection: $selection){ hour in
                    Text(hour)
                }.environment(\.editMode, $editMode)
            }
            
            if saveButton==true {
                Button(action: {
                    if isToogleOn==true {
                        workingHour=[String](selection2)
                        workingHour.sort()
                        firestoreDatabase.collection("Stadiums").document(currentUser!.uid).updateData(["WorkingHour2":workingHour]) { error in
                                if error != nil {
                                    titleInput="Hata"
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    titleInput="Başarılı"
                                    messageInput="Saatler düzenlendi."
                                    showingAlert.toggle()
                                    selection.removeAll(keepingCapacity: false)
                                    selection2.removeAll(keepingCapacity: false)
                                    editMode = .inactive
                                    saveButton=false
                                }
                            }
                    } else {
                        workingHour=[String](selection)
                        workingHour.sort()
                        firestoreDatabase.collection("Stadiums").document(currentUser!.uid).updateData(["WorkingHour":workingHour]) { error in
                                if error != nil {
                                    titleInput="Hata"
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    titleInput="Başarılı"
                                    messageInput="Saatler düzenlendi."
                                    showingAlert.toggle()
                                    selection.removeAll(keepingCapacity: false)
                                    selection2.removeAll(keepingCapacity: false)
                                    editMode = .inactive
                                    saveButton=false
                                }
                            }
                    }
                }) {
                    Text("Kaydet")
                }
            }
            
        }
    }
}

struct WorkingHours_Previews: PreviewProvider {
    static var previews: some View {
        WorkingHours()
    }
}
