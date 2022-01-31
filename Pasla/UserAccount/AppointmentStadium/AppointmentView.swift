//
//  AppointmentView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI

struct AppointmentView: View {
    @StateObject var stadiuminfo=StadiumInfoFromUserModel()
    
    var body: some View {
        VStack{
            List(stadiuminfo.nameFields,id:\.self){i in
                NavigationLink(destination: DateView(selectedField:i)){
                    Text(i)
                }
            }
                .navigationTitle(Text("Saha Seçimi"))
        }.onAppear{
            stadiuminfo.getDataFromInfoForUser()
        }
    }
}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView()
    }
}



