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
    @State var searchField=""
    
    var body: some View {
        VStack{
            HStack(spacing:15){
                Image(systemName: "magnifyingglass")//.font(.system(size: 23,weight: .bold))
                    .foregroundColor(.gray)
                TextField("Saha ara",text: $searchField)
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            List(searchField == "" ? stadiumNames : stadiumNames.filter{$0.contains(searchField)},id: \.self) { i in
                NavigationLink(destination: SelectedStadiumView(selectedStadium:i).onAppear(){
                    chosenStadiumName=i
                }){
                    Text(i)
                }
            }.listStyle(.plain)
        }.navigationTitle(Text(selectedTown)).navigationBarTitleDisplayMode(.inline)
            .onAppear{
            getStadiums()
            }.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
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

//ekrana tıklayınca klavyeyi kapatıyor.

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
