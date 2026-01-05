//
//  EventDetailView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct EventDetailView: View {
    let eventId: UUID
    @State private var event: Event?
    @State private var reservations: [ReservationWithEvent] = []
    @State private var searchText = ""
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .padding()
            } else if let event = event {
                VStack(spacing: 24) {
                    // Event Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Label(event.park, systemImage: "building.2")
                            Spacer()
                            Label(event.location, systemImage: "mappin.circle")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search reservations...", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Reservations List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Confirmed Reservations")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(filteredConfirmedReservations, id: \.reservation.id) { item in
                            ReservationCard(item: item)
                        }
                        
                        if !filteredWaitlistReservations.isEmpty {
                            Text("Waitlist")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ForEach(filteredWaitlistReservations, id: \.reservation.id) { item in
                                ReservationCard(item: item)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }
    
    private var filteredConfirmedReservations: [ReservationWithEvent] {
        let confirmed = reservations.filter { $0.reservation.status == "confirmed" }
        if searchText.isEmpty {
            return confirmed
        }
        return confirmed.filter {
            $0.reservation.guestName.localizedCaseInsensitiveContains(searchText) ||
            ($0.reservation.vipGuideName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.reservation.club33Number?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    private var filteredWaitlistReservations: [ReservationWithEvent] {
        let waitlist = reservations.filter { $0.reservation.status == "waitlist" }
        if searchText.isEmpty {
            return waitlist
        }
        return waitlist.filter {
            $0.reservation.guestName.localizedCaseInsensitiveContains(searchText) ||
            ($0.reservation.vipGuideName?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    private func loadData() async {
        // TODO: Load event and reservations
        await MainActor.run {
            isLoading = false
        }
    }
}
