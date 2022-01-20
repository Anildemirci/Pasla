//
//  CommentsView.swift
//  Pasla
//
//  Created by Anıl Demirci on 25.12.2021.
//

import SwiftUI

struct CommentsView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("11 müşteri oyu ile 4.5/5 puan.")
            List{
                VStack{
                    HStack(alignment:.top){
                        VStack(alignment: .leading){
                            Text("isim soyisim")
                            Text("tarih")
                        }
                        Spacer()
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                        Image(systemName: "star.fill")
                    }
                    Spacer()
                    Text("asdaskldjaslkdjasldsakjdşlsakdaslşdjkassadlmsadkadaldasdasdksaildşaksdşlaksdşlaskdadads")
                }
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
