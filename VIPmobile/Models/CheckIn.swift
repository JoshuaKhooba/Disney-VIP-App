//
//  CheckIn.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import Foundation

struct CheckIn: Identifiable, Codable {
    let id: UUID
    let reservationId: UUID
    let checkedInAt: Date
    let checkedInBy: UUID?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case reservationId = "reservation_id"
        case checkedInAt = "checked_in_at"
        case checkedInBy = "checked_in_by"
        case notes
    }
}
