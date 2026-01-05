//
//  NewReservationView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct NewReservationView: View {
    @State private var events: [Event] = []
    @State private var selectedEvent: Event?
    @State private var guestName = ""
    @State private var groupSize = "1"
    @State private var tourDate = Date()
    @State private var hasVipGuide = false
    @State private var vipGuideName = ""
    @State private var isClub33 = false
    @State private var club33Number = ""
    @State private var specialRequests = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Selection") {
                    Picker("Event", selection: $selectedEvent) {
                        Text("Select an event").tag(nil as Event?)
                        ForEach(events) { event in
                            Text("\(event.name) - \(event.park)").tag(event as Event?)
                        }
                    }
                }
                
                Section("Guest Information") {
                    TextField("Guest Name", text: $guestName)
                    
                    DatePicker("Event Date", selection: $tourDate, in: Date()..., displayedComponents: .date)
                    
                    HStack {
                        Text("Group Size")
                        Spacer()
                        TextField("1", text: $groupSize)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                Section {
                    Toggle("Has VIP Tour Guide", isOn: $hasVipGuide)
                    
                    if hasVipGuide {
                        TextField("VIP Guide Name", text: $vipGuideName)
                    }
                    
                    Toggle("Club 33 Member", isOn: $isClub33)
                    
                    if isClub33 {
                        TextField("Club 33 Number", text: $club33Number)
                    }
                }
                
                Section("Special Requests") {
                    TextEditor(text: $specialRequests)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: createReservation) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Create Reservation")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isLoading || !isFormValid)
                }
            }
            .navigationTitle("New Reservation")
            .alert("Reservation Status", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    private var isFormValid: Bool {
        guard selectedEvent != nil,
              !guestName.isEmpty,
              let size = Int(groupSize), size > 0 else {
            return false
        }
        
        if hasVipGuide && vipGuideName.isEmpty {
            return false
        }
        
        if isClub33 && club33Number.isEmpty {
            return false
        }
        
        return true
    }
    
    private func loadEvents() async {
        do {
            let fetchedEvents = try await SupabaseService.shared.fetchEvents()
            await MainActor.run {
                events = fetchedEvents
            }
        } catch {
            print("Error loading events: \(error)")
        }
    }
    
    private func createReservation() {
        guard let event = selectedEvent,
              let size = Int(groupSize) else {
            return
        }
        
        isLoading = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: tourDate)
        
        Task {
            do {
                let _ = try await SupabaseService.shared.createReservation(
                    eventId: event.id,
                    guestName: guestName,
                    groupSize: size,
                    tourDate: dateString,
                    hasVipGuide: hasVipGuide,
                    vipGuideName: hasVipGuide ? vipGuideName : nil,
                    isClub33: isClub33,
                    club33Number: isClub33 ? club33Number : nil,
                    specialRequests: specialRequests.isEmpty ? nil : specialRequests
                )
                
                await MainActor.run {
                    alertMessage = "Reservation created successfully!"
                    showAlert = true
                    isLoading = false
                    resetForm()
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    isLoading = false
                }
            }
        }
    }
    
    private func resetForm() {
        selectedEvent = nil
        guestName = ""
        groupSize = "1"
        tourDate = Date()
        hasVipGuide = false
        vipGuideName = ""
        isClub33 = false
        club33Number = ""
        specialRequests = ""
    }
}
