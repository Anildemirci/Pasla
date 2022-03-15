//
//  FindStadiumView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase
import Combine

struct FindStadiumView: View {
    
    @ObservedObject var findStadium=FindStadium()
    @State var stadiumNameArray=[String]()
    @State var searchField=""
    
    var body: some View {
            NavigationView{
                VStack {
                    HStack(){
                        Image(systemName: "magnifyingglass")//.font(.system(size: 23,weight: .bold))
                            .foregroundColor(.gray)
                        TextField("İlçe ara",text: $searchField)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                    List(searchField == "" ? findStadium.townArray : findStadium.townArray.filter{$0.town.contains(searchField)}){ towns in
                        NavigationLink(destination: StadiumNameView(selectedTown:towns.town).onAppear() {
                            chosenTown=towns.town
                        }) {
                            Text(towns.town)
                        }
                    }
                }.navigationTitle(Text("İstanbul")).navigationBarTitleDisplayMode(.inline)//başka şehirler eklenirse düzenle
            }
    }
}

struct FindStadiumView_Previews: PreviewProvider {
    static var previews: some View {
        FindStadiumView()
    }
}

struct townName: Identifiable {
    var id=UUID()
    var town:String
}

var chosenTown=""
var chosenStadiumName=""

class FindStadium : ObservableObject {
    @Published var nameArray=[String]()
    @Published var townArray=[townName]()
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    
    init() {
        let firestoreDatabase=Firestore.firestore()
         firestoreDatabase.collection("Stadiums").order(by: "Town",descending: false) .addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                self.townArray.removeAll(keepingCapacity: false)
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let Town = document.get("Town") as? String {
                            if self.nameArray.contains(Town) {
                                //zaten içeriyor.
                            } else {
                                self.nameArray.append(Town)
                                self.townArray.append(townName(town:Town))
                            }
                        }
                    }
                    self.didChange.send(self.townArray)
                }
            }
        }
    }
    
}
