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
    @State var selectedTown=""
    @State var stadiumNameArray=[String]()
    
    var body: some View {
        NavigationView {
            List(findStadium.townArray){ towns in
                NavigationLink(destination: StadiumNameView().onAppear() {
                    selectedTown=towns.town
                    chosenTown=selectedTown
                    let firestoreDatabase=Firestore.firestore()
                     firestoreDatabase.collection("Stadiums").order(by: "Name",descending: false).addSnapshotListener { (snapshot, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "Error")
                        } else {
                            if snapshot?.isEmpty != true && snapshot != nil {
                                stadiumNames.removeAll(keepingCapacity: false)
                            
                                for document in snapshot!.documents {
                                    
                                    if let Name = document.get("Town") as? String {
                                        if Name==self.selectedTown {
                                            let stadiumName=document.get("Name") as! String
                                            self.stadiumNameArray.append(stadiumName)
                                            stadiumNames.append(stadiumNameItem(name: stadiumName))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text(towns.town)
                }
            }
            .navigationBarTitle("İstanbul",displayMode:.large) //başka şehirler eklenirse düzenle
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

struct stadiumNameItem: Identifiable{
    var id=UUID()
    var name:String
}

var stadiumNames=[stadiumNameItem]()
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
