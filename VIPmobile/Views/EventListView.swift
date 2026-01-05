//
//  EventListView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct EventsListView: View {
    @State private var events: [EventWithStats] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Disney Special Events")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Text("Select an event to manage reservations")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(events) { eventWithStats in
                                    NavigationLink(destination: EventDetailView(eventId: eventWithStats.event.id)) {
                                        EventCard(eventWithStats: eventWithStats)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Events")
            .refreshable {
                await loadEvents()
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
        // TODO: Implement event loading with stats
        await MainActor.run {
            isLoading = false
        }
    }
}

struct EventCard: View {
    let eventWithStats: EventWithStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.blue)
                
                Text(eventWithStats.event.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 12) {
                Label(eventWithStats.event.park, systemImage: "building.2")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
                
                Label(eventWithStats.event.eventType.capitalized, systemImage: "sparkles")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
            }
            
            Text(eventWithStats.event.location)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider()
            
            HStack(spacing: 32) {
                VStack(alignment: .leading) {
                    Text("Reservations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(eventWithStats.reservationCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading) {
                    Text("Guests")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(eventWithStats.totalGuests) / \(eventWithStats.event.maxCapacity)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            if eventWithStats.waitlistCount > 0 {
                Text("\(eventWithStats.waitlistCount) on waitlist")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8)
    }
}
