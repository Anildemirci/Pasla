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
    @State var currentTime=""
    @State var documentID="" //diğer taraftan getir
    @State var field=""
    @State var status=""
    @StateObject var userInfo=UsersInfoModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
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
                        Text(chosenStadiumName)
                        Text("saha adı")
                        Text("tarih")
                        Text("saat")
                        Text("durumu")
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                        .lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.5).background(Color.white)
                    .cornerRadius(25)
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
                Button(action: {
                    
                }){
                    Text("İptal et")
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.height * 0.06)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            }
        }.background(Color("myGreen"))
    }
    
    
    func getDataFromDatabase(){
        firestoreDatabase.collection("Evaluation").document(chosenStadiumName).collection(chosenStadiumName).document(day+"-"+hour).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let comment=document.get("Comment") as! String
                        if comment != "" {
                            //yorum yapılmış yorumları kapat.
                        }
                        let score=document.get("Score") as! String
                        if score != "" {
                            //yorum yapılmamış yorum yaptır
                        }
                        if score != "Lütfen puan seçiniz" && comment != "" {
                            //eğer puan ve yorum yapılmmaışsa butona basılmasın
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
    
    func getCurrentTime(){
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
    }
    
    func getData(){
        for day in 0...13 {
            let hourToAdd=3
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
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        self.field=document.get("FieldName") as! String
                        self.day=document.get("AppointmentDate") as! String
                        self.hour=document.get("Hour") as! String
                        self.status=document.get("Status") as! String
                        
                        if self.status == "Onaylandı." {
                            if self.daysArray.contains(self.day) {
                                //yorum yapamazsın.
                                //cancelButton.isHidden=true
                            } else {
                                //yorum yap puanla
                            }
                        }
                        self.getDataFromDatabase()
                    }
                }
    }
    
    func sendClicked(chosenPoint:String){
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "StadiumName":chosenStadiumName,
                           "FieldName":field,
                           "Date":day,
                           "Hour":hour,
                           "Status":status,
                           "Comment":comment,
                           "Score":chosenPoint,
                           "FullName":userInfo.userName+" "+userInfo.userSurname,
                           "CommentDate":currentTime] as [String:Any]
        
        if chosenPoint != "" && comment != "" {
            //sadece yorum ya da oylama yaptırırsan güncelleme yaptır database'e.
            firestoreDatabase.collection("Evaluation").document(chosenStadiumName).collection(chosenStadiumName).document(day+"-"+hour).setData(firestoreUser) {
                error in
                if error != nil {
                    // error localized
                } else {
                    //başarılı ve profile yönlendir
                }
            }
        } else {
            //lütfen boş bırakmayınız.
        }
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
    }
}
