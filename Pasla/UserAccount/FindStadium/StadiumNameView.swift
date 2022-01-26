//
//  StadiumNameView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase



struct StadiumNameView: View {
    
    var body: some View {
        VStack{
            List(stadiumNames) { i in
                NavigationLink(destination: SelectedStadiumView(selectedStadium:i.name).onAppear(){
                    chosenStadiumName=i.name
                }){
                    Text(i.name)
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
