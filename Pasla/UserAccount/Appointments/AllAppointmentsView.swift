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
            Button(action: {
                
            }){
                Text("Geçmiş Randevular")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.red)
            }
            Spacer()
                .frame(height: 35.0)
            Button(action: {
                
            }){
                Text("Onaylanmış Randevular")
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.green)
                    .foregroundColor(Color.white)
               
            }
            Spacer()
                .frame(height: 35.0)
            Button(action: {
                
            }){
                Text("Onay Bekleyen Randevular")
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.125)
                    .background(Color.yellow)
                    .foregroundColor(Color.white)
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
