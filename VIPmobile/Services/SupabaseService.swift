#if canImport(Supabase)
import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://nxlsyihespmkkujeiqjb.supabase.co")!,
            supabaseKey: "sb_publishable__d-35JebywbjUR5S_U5ecQ_Yt-bdZL3"
        )
    }
    
    // MARK: - Authentication
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() async throws -> AppUser? {
        do {
            // Access current user from session
            let session = try client.auth.session
            return AppUser(from: session.user)
        } catch {
            return nil
        }
    }
    
    // MARK: - Events
    func fetchEvents() async throws -> [Event] {
        try await client
            .from("events")
            .select()
            .order("name")
            .execute()
            .value
    }
    
    func fetchEvent(id: UUID) async throws -> Event {
        try await client
            .from("events")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
    }
    
    // MARK: - Reservations
    func fetchReservations(from date: String, status: String? = nil) async throws -> [Reservation] {
        var query = client
            .from("reservations")
            .select()
            .gte("tour_date", value: date)
        
        if let status = status {
            query = query.eq("status", value: status)
        } else {
            query = query.neq("status", value: "cancelled")
        }
        
        return try await query.order("tour_date").execute().value
    }
    
    func createReservation(
        eventId: UUID,
        guestName: String,
        groupSize: Int,
        tourDate: String,
        hasVipGuide: Bool,
        vipGuideName: String?,
        isClub33: Bool,
        club33Number: String?,
        specialRequests: String?
    ) async throws -> Reservation {
        // Check capacity
        let confirmedReservations: [Reservation] = try await client
            .from("reservations")
            .select()
            .eq("event_id", value: eventId)
            .eq("tour_date", value: tourDate)
            .eq("status", value: "confirmed")
            .execute()
            .value
        
        let currentCapacity = confirmedReservations.reduce(0) { $0 + $1.groupSize }
        let status = (currentCapacity + groupSize <= 250) ? "confirmed" : "waitlist"
        
        let user = try await getCurrentUser()
        guard let userId = user?.id else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        struct ReservationInsert: Encodable {
            let event_id: String
            let user_id: String
            let guest_name: String
            let group_size: Int
            let tour_date: String
            let status: String
            let has_vip_guide: Bool
            let vip_guide_name: String?
            let is_club_33: Bool
            let club33_number: String?
            let special_requests: String?
        }
        
        let reservationData = ReservationInsert(
            event_id: eventId.uuidString,
            user_id: userId.uuidString,
            guest_name: guestName,
            group_size: groupSize,
            tour_date: tourDate,
            status: status,
            has_vip_guide: hasVipGuide,
            vip_guide_name: vipGuideName,
            is_club_33: isClub33,
            club33_number: club33Number,
            special_requests: specialRequests
        )
        
        return try await client
            .from("reservations")
            .insert(reservationData)
            .select()
            .single()
            .execute()
            .value
    }
    
    func cancelReservation(id: UUID) async throws {
        try await client
            .from("reservations")
            .update(["status": "cancelled"])
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    // MARK: - Check-ins
    func checkIn(reservationId: UUID, notes: String?) async throws {
        let user = try await getCurrentUser()
        
        struct CheckInInsert: Encodable {
            let reservation_id: String
            let checked_in_by: String?
            let notes: String?
        }
        
        let checkInData = CheckInInsert(
            reservation_id: reservationId.uuidString,
            checked_in_by: user?.id.uuidString,
            notes: notes
        )
        
        try await client
            .from("check_ins")
            .insert(checkInData)
            .execute()
    }
}
#else
import Foundation

// Fallback stub so the project compiles without the Supabase package.
// All methods throw at runtime to indicate missing dependency.
class SupabaseService {
    static let shared = SupabaseService()

    enum StubError: Error, LocalizedError {
        case missingSupabaseDependency
        
        var errorDescription: String? {
            switch self {
            case .missingSupabaseDependency:
                return "Supabase package is not installed. Please add the Supabase Swift package to your Xcode project:\n1. In Xcode, go to File > Add Package Dependencies\n2. Enter: https://github.com/supabase/supabase-swift\n3. Select version 1.0.0 or later\n4. Add it to your target"
            }
        }
    }

    private init() {}

    // MARK: - Authentication
    func signIn(email: String, password: String) async throws {
        throw StubError.missingSupabaseDependency
    }

    func signUp(email: String, password: String) async throws {
        throw StubError.missingSupabaseDependency
    }

    func signOut() async throws {
        throw StubError.missingSupabaseDependency
    }

    func getCurrentUser() async throws -> AppUser? {
        throw StubError.missingSupabaseDependency
    }

    // MARK: - Events
    func fetchEvents() async throws -> [Event] {
        throw StubError.missingSupabaseDependency
    }

    func fetchEvent(id: UUID) async throws -> Event {
        throw StubError.missingSupabaseDependency
    }

    // MARK: - Reservations
    func fetchReservations(from date: String, status: String? = nil) async throws -> [Reservation] {
        throw StubError.missingSupabaseDependency
    }

    func createReservation(
        eventId: UUID,
        guestName: String,
        groupSize: Int,
        tourDate: String,
        hasVipGuide: Bool,
        vipGuideName: String?,
        isClub33: Bool,
        club33Number: String?,
        specialRequests: String?
    ) async throws -> Reservation {
        throw StubError.missingSupabaseDependency
    }

    func cancelReservation(id: UUID) async throws {
        throw StubError.missingSupabaseDependency
    }

    // MARK: - Check-ins
    func checkIn(reservationId: UUID, notes: String?) async throws {
        throw StubError.missingSupabaseDependency
    }
}
#endif
