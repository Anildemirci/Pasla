//
//  PaslaApp.swift
//  Pasla
//
//  Created by Anıl Demirci on 13.12.2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct PaslaApp: App {
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    //@StateObject var usersinfo=UsersInfoModel()
    @Environment(\.scenePhase) var scenePhase
    //init() {FirebaseApp.configure()}
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            
            let currentUser=Auth.auth().currentUser
            //let firebaseDatabase=Firestore.firestore()
            
            if currentUser != nil {
                StadiumAccountView()
            } else {
                HomeView()
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
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

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

/*
 .onAppear{
     DispatchQueue.main.asyncAfter(deadline: .now()+2){
         showingAlert.toggle()
     }
 
 2 saniye sonra uyarıyı getiriyor. uygulama açılırken logo gösterdikten sonra ekrana yönlendirmesi için kullanabilirsin.
 */


/*
func getData(){
    let currentUser=Auth.auth().currentUser
    let firebaseDatabase=Firestore.firestore()
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    
    if currentUser != nil {
        firebaseDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        userTypeArray.append(userType)
                        if userTypeArray.contains(currentUser!.uid) {
                            firebaseDatabase.collection("Users").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents {
                                        if let userName=document.get("Name") as? String{
                                            if userName == "" {
                                                screen="userinfo"
                                            } else {
                                                screen="userprofile"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        firebaseDatabase.collection("Stadiums").addSnapshotListener { (snapshot, error) in
            if error==nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        stadiumTypeArray.append(userType)
                        if stadiumTypeArray.contains(currentUser!.uid) {
                            
                            firebaseDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents {
                                        if let stadiumName=document.get("Name") as? String{
                                            if stadiumName == "" {
                                                screen="stadiuminfo"
                                            } else {
                                                screen="stadiumprofile"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
*/
