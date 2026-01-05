//
//  VIPmobileApp.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

@main
struct DisneyVIPToursApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

