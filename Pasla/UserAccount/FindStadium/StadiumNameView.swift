//
//  StadiumNameView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct StadiumNameView: View {
    @State var stadiumNames=[String]()
    @State var selectedTown=""
    
    var body: some View {
        VStack{
            List(stadiumNames,id: \.self) { i in
                NavigationLink(destination: SelectedStadiumView(selectedStadium:i).onAppear(){
                    chosenStadiumName=i
                }){
                    Text(i)
                }
            }
        }.onAppear{
            getStadiums()
        }
    }
    
    func getStadiums(){
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
                                stadiumNames.append(stadiumName)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct StadiumNameView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumNameView()
    }
}
