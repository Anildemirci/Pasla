//
//  SignUpView.swift
//  Pasla
//
//  Created by Anıl Demirci on 14.12.2021.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
            VStack{
                Image("paslaLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.5)
                    .padding()
                Spacer()
                NavigationLink(destination: UserSignUpView()){
                    Text("Kullanıcı")
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                }.padding()
                NavigationLink(destination: StadiumSignUpView()){
                    Text("Halı Saha")
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                }
                Spacer()
            }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
