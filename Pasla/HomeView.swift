//
//  ContentView.swift
//  Pasla
//
//  Created by Anıl Demirci on 13.12.2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack{
                Image("paslaLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.5)
                    .padding()
                Spacer()
                NavigationLink(destination: LoginView()){
                    Text("Giriş Yap")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                }
                NavigationLink(destination: SignUpView()){
                    Text("Üye Ol")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .background(Color("myGreen"))
                            .foregroundColor(Color.white)
                            .clipShape(Capsule())
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
            HomeView().previewDevice("iPhone 12 Pro Max")
        }
    }
}
