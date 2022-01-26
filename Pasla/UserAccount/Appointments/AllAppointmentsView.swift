//
//  AllAppointmentsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI

struct AllAppointmentsView: View {
    var body: some View {
        VStack{
            Spacer()
            NavigationLink(destination: UserAppointmentsView(status: "Onaylandı.", today: "next")){
                Text("Onaylanan Randevular")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.green)
            }
            Spacer()
                .padding()
                .frame(height: 15.0)
            NavigationLink(destination: UserAppointmentsView(status: "Onay bekliyor.", today: "")){
                Text("Onay Bekleyen Randevular")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.yellow)
            }
            Spacer()
                .padding()
                .frame(height: 15.0)
            NavigationLink(destination: UserAppointmentsView(status: "Onaylandı.", today: "past")){
                Text("Geçmiş Randevular")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.red)
            }
            Spacer()
        }
    }
}

struct AllAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllAppointmentsView()
    }
}
