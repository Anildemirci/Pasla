//
//  PaslaApp.swift
//  Pasla
//
//  Created by Anıl Demirci on 13.12.2021.
//

import SwiftUI
import Firebase

@main
struct PaslaApp: App {
    //@UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
              print("App is active")
            case .inactive:
              print("App is inactive")
            case .background:
              print("App is in background")
            @unknown default:
              print("Oh - interesting: I received an unexpected new value.")
            }
          }
    }
}

/*
 .onAppear{
     DispatchQueue.main.asyncAfter(deadline: .now()+2){
         showingAlert.toggle()
     }
 
 2 saniye sonra uyarıyı getiriyor. uygulama açılırken logo gösterdikten sonra ekrana yönlendirmesi için kullanabilirsin.
 */



