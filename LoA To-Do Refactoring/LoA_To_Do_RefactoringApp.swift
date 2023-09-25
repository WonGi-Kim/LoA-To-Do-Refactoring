//
//  LoA_To_Do_RefactoringApp.swift
//  LoA To-Do Refactoring
//
//  Created by 김원기 on 2023/09/16.
//

import SwiftUI
import Firebase

@main
struct LoA_To_Do_RefactoringApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
