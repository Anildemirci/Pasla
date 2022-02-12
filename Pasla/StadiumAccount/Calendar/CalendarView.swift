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
    @State var shown=false
    var body: some View {
        NavigationView{
            List(stadiuminfo.nameFields,id:\.self){i in
                            NavigationLink(destination: ConfirmDateView(selectedField:i,stadiumName: stadiuminfo.stadiumName)){
                                Text(i)
                            }
                        }
            .navigationTitle(Text("Saha Seçimi"))
            .navigationBarItems(trailing:
                                    Button(action: {
                shown.toggle()
                                    }){
                                        Text("Düzenle")
                                        //Image(systemName: "Düzenle").resizable().frame(width: 30, height: 30)
                                            .sheet(isPresented: $shown) { () -> WorkingHours in
                                                return WorkingHours()
                                            }
                                    }
                                )
        }
        .onAppear{
            stadiuminfo.getDataForStadium()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
