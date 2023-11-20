//
//  LoA_To_Do_RefactoringApp.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/16.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@main
struct LoA_To_Do_RefactoringApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
