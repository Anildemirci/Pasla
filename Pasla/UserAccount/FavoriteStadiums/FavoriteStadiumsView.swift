//
//  FavoriteStadiumsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct FavoriteStadiumsView: View {
    @StateObject var userInfo=UsersInfoModel()
    
    var body: some View {
        NavigationView{
            List(userInfo.userFavStadium,id:\.self){ stadiums in
                NavigationLink(destination: SelectedStadiumView(selectedStadium: stadiums).onAppear() {
                    chosenStadiumName=stadiums
                }){
                    Text(stadiums)
                }
            }.navigationBarTitle("Favoriler",displayMode:.large)
        }.onAppear{
            userInfo.getDataForUser()
        }
    }
}

struct FavoriteStadiumsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteStadiumsView()
    }
}
