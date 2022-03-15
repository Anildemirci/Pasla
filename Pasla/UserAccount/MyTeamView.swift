//
//  MyTeamView.swift
//  Pasla
//
//  Created by Anıl Demirci on 15.01.2022.
//

import SwiftUI

struct MyTeamView: View {
    var body: some View {
        NavigationView {
            Text("Yakında..")
                .navigationTitle(Text("Takımım")).navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MyTeamView_Previews: PreviewProvider {
    static var previews: some View {
        MyTeamView()
    }
}
