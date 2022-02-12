//
//  FieldInformationsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct FieldInformationsView: View {
    @State var fieldname=""
    @State var checkInfos=false
    @State var fieldSize=""
    @State var fieldPrice=""
    @State var deposit=""
    
    var body: some View {
        VStack{
            Spacer()
            Text("Saha Bilgileri")
                .padding()
                .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                .background(Color.white)
            Spacer()
            VStack{
                if checkInfos==false {
                    Group{
                        Text(fieldname)
                        Text("Henüz saha boyutu hakkında bilgi verilmedi ")
                        Text("Henüz saha fiyatı hakkında bilgi verilmedi ")
                        Text("Henüz kapora hakkında bilgi verilmedi ")
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                } else {
                    Group{
                        Text(fieldname)
                        Text(fieldSize=="" ? "Henüz saha boyutu hakkında bilgi verilmedi":("Saha boyutu: \(fieldSize)"))
                        Text(fieldPrice=="" ? "Henüz saha fiyatı hakkında bilgi verilmedi":("Saha fiyatı: \(fieldPrice)"))
                        Text(deposit=="" ? "Henüz kapora hakkında bilgi verilmedi":("Kapora bilgisi: \(deposit)"))
                    }.font(.title3)
                        .padding()
                        .foregroundColor(Color("myGreen"))
                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                        .border(Color("myGreen"), width: 1)
                        .multilineTextAlignment(.leading)
                }
            }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45).background(Color.white)
                .cornerRadius(25)
            Spacer()
        }.background(Color("myGreen"))
            .onAppear{
                checkInfo()
            }
    }
    
    func getInfos(){
        let fb=Firestore.firestore()
        
        fb.collection("FieldInformations").document(chosenStadiumName).collection("Fields").document(fieldname).addSnapshotListener { (document, error) in
            if error == nil {
                if let price=document?.get("Price") as? String {
                    fieldPrice=price
                }
                if let size=document?.get("Size") as? String {
                    fieldSize=size
                }
                if let deposit=document?.get("Deposit") as? String {
                    self.deposit=deposit
                }
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
                        if document.documentID==fieldname {
                            checkInfos=true
                            getInfos()
                        }
                    }
                }
                
            }
        }
    }
    
}

struct FieldInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        FieldInformationsView()
    }
}
