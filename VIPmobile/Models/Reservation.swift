//
//  Reservation.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import Foundation

struct Reservation: Identifiable, Codable {
    let id: UUID
    let eventId: UUID
    let userId: UUID
    let guestName: String
    let groupSize: Int
    let tourDate: String
    let status: String
    let hasVipGuide: Bool
    let vipGuideName: String?
    let isClub33: Bool
    let club33Number: String?
    let specialRequests: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case userId = "user_id"
        case guestName = "guest_name"
        case groupSize = "group_size"
        case tourDate = "tour_date"
        case status
        case hasVipGuide = "has_vip_guide"
        case vipGuideName = "vip_guide_name"
        case isClub33 = "is_club_33"
        case club33Number = "club33_number"
        case specialRequests = "special_requests"
        case createdAt = "created_at"
    }
}

struct ReservationWithEvent {
    let reservation: Reservation
    let event: Event
    let checkIn: CheckIn?
}
