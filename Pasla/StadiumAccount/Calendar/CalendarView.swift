//
//  CalendarView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI
import Firebase

struct CalendarView: View {
    @StateObject var stadiuminfo=UsersInfoModel()
    
    var body: some View {
        NavigationView{
            List(stadiuminfo.nameFields,id:\.self){i in
                            NavigationLink(destination: ConfirmDateView(selectedField:i,stadiumName: stadiuminfo.stadiumName)){
                                Text(i)
                            }
                        }
                            .navigationTitle(Text("Saha Seçimi"))
        }.onAppear{
            stadiuminfo.getDataForStadium()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
