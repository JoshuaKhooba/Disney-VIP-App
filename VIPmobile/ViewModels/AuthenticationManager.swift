//
//  AuthenticationManager.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: AppUser?
    
    private let supabase = SupabaseService.shared
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        Task {
            do {
                currentUser = try await supabase.getCurrentUser()
                await MainActor.run {
                    isAuthenticated = currentUser != nil
                }
            } catch {
                await MainActor.run {
                    isAuthenticated = false
                }
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        try await supabase.signIn(email: email, password: password)
        currentUser = try await supabase.getCurrentUser()
        await MainActor.run {
            isAuthenticated = true
        }
    }
    
    func signOut() async throws {
        try await supabase.signOut()
        await MainActor.run {
            isAuthenticated = false
            currentUser = nil
        }
    }
}
