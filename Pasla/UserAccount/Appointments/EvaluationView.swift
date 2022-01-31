//
//  EvaluationView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct EvaluationView: View {
    
    @State var comment=""
    @State var points=["Lütfen puan seçiniz","1-Çok kötü","2-Kötü","3-Orta","4-İyi","5-Çok iyi"]
    @State var selectedPoint="Lütfen puan seçiniz"
    @State var daysArray=[String]()
    @State var day=""
    @State var hour=""
    @State var documentID=""
    @State var currentTime=""
    @State var field=""
    @State var status=""
    @State var messageInput=""
    @State var titleInput=""
    @State var button=""
    @State var button1=""
    @State var button2=""
    @State var stadiumname=""
    @State var showComment=true
    @State var showCancelButton=true
    @State var shown=false
    @State var alertType:AlertType?
    
    @StateObject var userInfo=UsersInfoModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    enum AlertType: Identifiable{
        case confirmAlert,showAlert
        
        var id: Int{
            hashValue
        }
    }
    
    var body: some View {
        VStack{
            ScrollView(.vertical,showsIndicators: false){
                Spacer()
                Text("Randevu Bilgileri")
                    .font(.largeTitle)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                    .foregroundColor(Color.white)
                    //.background(Color.white)
                Spacer()
                VStack{
                    Group{
                        Text(stadiumname)
                        Text(field)
                        Text(day)
                        Text(hour)
                        Text(status)
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                        .lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.5).background(Color.white)
                    .cornerRadius(25)
                if showComment==true {
                    Spacer()
                    Text("Yorumla")
                        .font(.largeTitle)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                        .foregroundColor(Color.white)
                    VStack{
                        TextField("yorum ekle", text: $comment)
                            .padding()
                            .background(Color.white)
                            .border(Color("myGreen"), width: 1)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                        HStack {
                            Text("Puan: ")
                                .foregroundColor(Color.black)
                            Spacer()
                            Picker("Lütfen puan seçiniz", selection: $selectedPoint) {
                                ForEach(points,id:\.self) { score in
                                    Text(score)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .accentColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                        }
                            .padding()
                            .background(Color.white)
                            .border(Color("myGreen"), width: 1)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        Button(action: {
                            button="send"
                            titleInput="Onaylıyor musunuz?"
                            messageInput="tekrar yorum yapamazsınız."
                            button1="Evet"
                            button2="Hayır"
                            alertType = .confirmAlert
                        }){
                            Text("Gönder")
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.height * 0.06)
                                .background(Color("myGreen"))
                                .foregroundColor(Color.white)
                                .clipShape(Capsule())
                        }
                    }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.30).background(Color.white)
                        .cornerRadius(25)
                } else if showComment==false && showCancelButton==false {
                    Text("Yorum ve puanlama yaptığınız için teşekkür ederiz.")
                        .padding()
                        .foregroundColor(Color.white)
                    //onaylanmayan ve reddedilen randevuları firabaseden çekmiyor. Eğer çekersen ona göre şikayet mesaj vs. butonları koy.
                } else {
                    Spacer()
                        .frame(height: 35.0)
                    Button(action: {
                        button="cancel"
                        titleInput="İptal etmek istediğinize emin misiniz?"
                        messageInput=""
                        button1="Evet"
                        button2="Hayır"
                        alertType = .confirmAlert
                    }){
                        Text("İptal et")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.height * 0.06)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                    }
                }
            }
            
        }.onAppear{
            getData()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(item:$alertType){ type in
            switch type {
            case .showAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Ok!")){
                    if titleInput=="Başarılı" {
                        shown.toggle()
                    }
                })
            case .confirmAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput),
                             primaryButton: .default(Text(button1)){
                           if button=="cancel" {
                               cancelClicked()
                           } else if button=="send" {
                               sendClicked(chosenPoint: selectedPoint)
                           }
                       },
                             secondaryButton: .default(Text(button2))
                       )
            }
        }
        .fullScreenCover(isPresented: $shown) { () -> UserAccountView in
            return UserAccountView()
        }
        .background(Color("myGreen"))
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
    
    func getCurrentTime(){
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
    }
    
    func getData(){
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
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).addSnapshotListener({ (snapshot, error) in
            if error != nil {
                titleInput="Error"
                messageInput=error?.localizedDescription ?? "Sistem hatası lütfen tekrar deneyiniz."
                alertType = .showAlert
            } else {
                for document in snapshot!.documents {
                    if document.documentID==documentID {
                        stadiumname=document.get("StadiumName") as! String
                        field=document.get("FieldName") as! String
                        day=document.get("AppointmentDate") as! String
                        hour=document.get("Hour") as! String
                        status=document.get("Status") as! String
                                
                            if status == "Onaylandı."  {
                                if daysArray.contains(day) {
                                showComment=false
                                //saate göre düzenle eğer maç saati geçtiyse yorum yapsın.
                                } else {
                                    firestoreDatabase.collection("Evaluation").document(stadiumname).collection(stadiumname).document(documentID).addSnapshotListener { (snapshot, error) in
                                        if error != nil {
                                            //hata var
                                        } else {
                                            for document in snapshot!.documentID {
                                                if let commentt=snapshot!.get("Comment") as? String {
                                                    if commentt == "" {
                                                        showComment=true
                                                    } else {
                                                        showComment=false
                                                        showCancelButton=false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else if status == "Onay bekliyor." {
                                if daysArray.contains(day) {
                                    showComment=false
                                } else {
                                    showComment=false
                                }
                            } else {
                                showComment=false
                            }
                    }
                }
            }
        })
            
            
    }
    
    func sendClicked(chosenPoint:String){
        
        getCurrentTime()
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email,
                           "StadiumName":stadiumname,
                           "FieldName":field,
                           "Date":day,
                           "Hour":hour,
                           "Status":status,
                           "Comment":comment,
                           "Score":chosenPoint,
                           "FullName":userInfo.userName+" "+userInfo.userSurname,
                           "CommentDate":currentTime] as [String:Any]
        
        if chosenPoint != "Lütfen puan seçiniz" && comment != "" {
            //sadece yorum ya da oylama yaptırırsan güncelleme yaptır database'e.
            firestoreDatabase.collection("Evaluation").document(stadiumname).collection(stadiumname).document(documentID).setData(firestoreUser) {
                error in
                if error != nil {
                    titleInput="Hata"
                    messageInput=error?.localizedDescription ?? "Sistem hatası lütfen tekrar deneyiniz."
                    alertType = .showAlert
                } else {
                    titleInput="Başarılı"
                    messageInput="Yorum ve puanlamanız için teşekkür ederiz."
                    alertType = .showAlert
                }
            }
        } else {
            titleInput="Hata"
            messageInput="Lütfen yorum/puan kısmını boş bırakmayınız."
            alertType = .showAlert
        }
    }
    
    func cancelClicked(){
        firestoreDatabase.collection("StadiumAppointments").document(stadiumname).collection(stadiumname).document(documentID).updateData(["Status":"İptal edildi."])
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(documentID).updateData(["Status":"İptal edildi."])
        firestoreDatabase.collection("Calendar").document(stadiumname).collection(field).document(documentID).updateData(["Status":"İptal edildi."])
        titleInput="Başarılı"
        messageInput="Randevunuz iptal edilmiştir."
        alertType = .showAlert
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
    }
}
