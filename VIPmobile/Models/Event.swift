//
//  Event.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let park: String
    let eventType: String
    let location: String
    let maxCapacity: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case park
        case eventType = "event_type"
        case location
        case maxCapacity = "max_capacity"
    }
}

struct EventWithStats: Identifiable {
    let event: Event
    let reservationCount: Int
    let totalGuests: Int
    let waitlistCount: Int
    
    var id: UUID { event.id }
}
