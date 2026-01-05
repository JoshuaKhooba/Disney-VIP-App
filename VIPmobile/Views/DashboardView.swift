//
//  DashboardView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var reservations: [ReservationWithEvent] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    VStack(spacing: 24) {
                        statsGrid
                        
                        if !todayReservations.isEmpty {
                            reservationSection(
                                title: "Today's Reservations",
                                reservations: todayReservations
                            )
                        }
                        
                        reservationSection(
                            title: "Upcoming Reservations",
                            reservations: upcomingReservations
                        )
                        
                        if !waitlistReservations.isEmpty {
                            reservationSection(
                                title: "Waitlist",
                                reservations: waitlistReservations
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await loadData()
            }
        }
        .task {
            await loadData()
        }
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(title: "Today's Events", value: "\(todayReservations.count)", subtitle: "\(checkedInCount) checked in")
            StatCard(title: "Total Guests", value: "\(totalGuests)", subtitle: "\(confirmedReservations.count) confirmed")
            StatCard(title: "With VIP Guide", value: "\(vipGuideCount)", subtitle: "Premium service", color: .blue)
            StatCard(title: "Waitlist", value: "\(waitlistReservations.count)", subtitle: "Awaiting spots", color: .orange)
        }
    }
    
    private func reservationSection(title: String, reservations: [ReservationWithEvent]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(reservations, id: \.reservation.id) { item in
                ReservationCard(item: item)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private var confirmedReservations: [ReservationWithEvent] {
        reservations.filter { $0.reservation.status == "confirmed" }
    }
    
    private var waitlistReservations: [ReservationWithEvent] {
        reservations.filter { $0.reservation.status == "waitlist" }
    }
    
    private var todayReservations: [ReservationWithEvent] {
        confirmedReservations.filter { $0.reservation.tourDate == today }
    }
    
    private var upcomingReservations: [ReservationWithEvent] {
        confirmedReservations.filter { $0.reservation.tourDate > today }
    }
    
    private var totalGuests: Int {
        confirmedReservations.reduce(0) { $0 + $1.reservation.groupSize }
    }
    
    private var vipGuideCount: Int {
        confirmedReservations.filter { $0.reservation.hasVipGuide }.count
    }
    
    private var checkedInCount: Int {
        todayReservations.filter { $0.checkIn != nil }.count
    }
    
    // MARK: - Data Loading
    private func loadData() async {
        do {
            let fetchedReservations = try await SupabaseService.shared.fetchReservations(from: today)
            // TODO: Fetch events and check-ins for each reservation
            await MainActor.run {
                isLoading = false
            }
        } catch {
            print("Error loading data: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    var color: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ReservationCard: View {
    let item: ReservationWithEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(displayName)
                        .font(.headline)
                    
                    Text(item.event.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if item.reservation.hasVipGuide {
                    Image(systemName: "star.fill")
                        .foregroundColor(.blue)
                }
                
                if item.reservation.isClub33 {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            HStack {
                Label(item.reservation.tourDate, systemImage: "calendar")
                Spacer()
                Label("\(item.reservation.groupSize) guests", systemImage: "person.3.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            if item.checkIn == nil && item.reservation.status == "confirmed" {
                Button(action: {}) {
                    Text("Check In")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.8, green: 0.2, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4)
        .padding(.horizontal)
    }
    
    private var displayName: String {
        if item.reservation.hasVipGuide, let guideName = item.reservation.vipGuideName {
            return "\(guideName) - \(item.reservation.guestName)"
        } else if item.reservation.isClub33, let club33Number = item.reservation.club33Number {
            return "\(item.reservation.guestName) (Club 33 #: \(club33Number))"
        } else {
            return item.reservation.guestName
        }
    }
}
