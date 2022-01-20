//
//  StadiumInformationsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI
import Firebase

struct StadiumInformationsView: View {
    
    @State var shown=false
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    @ObservedObject var infomodel=infoModel()
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(height: 25.0)
                HStack{
                    Image(systemName: "map.fill")
                        .resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 50.0, height: 50.0)
                        .aspectRatio(contentMode: .fill)
                    Text(infomodel.address)
                            .font(.title3)
                }
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                .background(Color.white)
                .cornerRadius(25)
                Spacer()
                    .frame(height: 25.0)
                VStack{
                    Spacer()
                    Text("Açılış saati: \(infomodel.open)")
                        .font(.title3)
                    Spacer()
                    Text("Kapanış saati: \(infomodel.close)")
                        .font(.title3)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.15)
                .background(Color.white)
                .cornerRadius(25)
                Spacer()
                Text("Saha Hakkında").font(.title).foregroundColor(.white)
                List(infomodel.infos,id:\.self){ element in
                    Text(element) //düzelt
                }
            }.background(Color("myGreen"))
                .navigationBarItems(trailing:
                    Button(action: {
                    shown.toggle()
                    }){
                        Image(systemName: "plus").resizable().frame(width: 30, height: 30)
                            .sheet(isPresented: $shown) { () -> StadiumEditView in
                                return StadiumEditView()
                            }
                    }
                )
        }
    }
}

struct StadiumInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumInformationsView()
    }
}

class infoModel : ObservableObject {
    
    @Published var infos = [String]()
    @Published var address=""
    @Published var open=""
    @Published var close=""
    //class dosyası yarat her yerde kullan
    init(){
        let db=Firestore.firestore()
        db.collection("Stadiums").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                let address=snapshot?.get("Address") as! String
                self.address=address
                if let openTime=snapshot?.get("Opened") as? String {
                    self.open=openTime
                }
                if let closeTime=snapshot?.get("Closed") as? String {
                    self.close=closeTime
                }
                if let info=snapshot?.get("Informations") as? [String] {
                    self.infos=info
                }
            }
        }
    }
}

