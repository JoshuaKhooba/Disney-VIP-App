//
//  MainTabView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            EventsListView()
                .tabItem {
                    Label("Events", systemImage: "star.fill")
                }
            
            NewReservationView()
                .tabItem {
                    Label("New Reservation", systemImage: "plus.circle.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color(red: 0.8, green: 0.2, blue: 0.2))
    }
}
