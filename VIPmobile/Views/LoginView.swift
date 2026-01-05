//
//  LoginView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Disney VIP Tours")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Employee Portal")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 32)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Disney Employee Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("firstname.lastname@disney.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            SecureField("Enter password", text: $password)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        if showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Button(action: handleLogin) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.8, green: 0.2, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(isLoading)
                        
                        Button(action: { showSignUp = true }) {
                            Text("Don't have an account? Sign up")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.8, green: 0.2, blue: 0.2))
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    private func handleLogin() {
        guard validateEmail(email) else {
            errorMessage = "Please use your Disney employee email (firstname.lastname@disney.com)"
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func validateEmail(_ email: String) -> Bool {
        // More flexible regex that allows uppercase, numbers, hyphens, and multiple dots
        // Still requires @disney.com domain
        let regex = "^[a-zA-Z0-9._-]+@disney\\.com$"
        return email.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
