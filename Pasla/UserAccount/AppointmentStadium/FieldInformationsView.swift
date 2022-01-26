//
//  FieldInformationsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI

struct FieldInformationsView: View {
    
    var body: some View {
        VStack{
            Spacer()
            Text("Saha Bilgileri")
                .padding()
                .frame(width: UIScreen.main.bounds.width * 1,height: UIScreen.main.bounds.height * 0.075)
                .background(Color.white)
            Spacer()
            VStack{
                Group{
                    Text("Saha 1")
                    Text("Henüz saha boyutu hakkında bilgi verilmedi ")
                    Text("Henüz saha fiyatı hakkında bilgi verilmedi ")
                    Text("Henüz kapora hakkında bilgi verilmedi ")
                }.font(.title3)
                    .padding()
                    .foregroundColor(Color("myGreen"))
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.07).background(Color.white)
                    .border(Color("myGreen"), width: 1)
                    .multilineTextAlignment(.leading)
            }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45).background(Color.white)
                .cornerRadius(25)
            Spacer()
        }.background(Color("myGreen"))
    }
}

struct FieldInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        FieldInformationsView()
    }
}
