//
//  User.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import Foundation
#if canImport(Supabase)
import Supabase

// Wrapper to provide consistent access to user properties
public struct AppUser {
    public let id: UUID
    public let email: String?
    
    public init(from user: User) {
        self.id = user.id
        // In Supabase Swift SDK, email is typically accessible directly
        // If it's not available, it will be nil
        self.email = user.email
    }
}
#else
// Stub User type for when Supabase is not available
public struct AppUser {
    public let id: UUID
    public let email: String?
    
    public init(id: UUID, email: String?) {
        self.id = id
        self.email = email
    }
}
#endif

