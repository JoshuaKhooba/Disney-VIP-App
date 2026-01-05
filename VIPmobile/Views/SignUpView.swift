//
//  SignUpView.swift
//  VIPmobile
//
//  Created by Joshua Khooba on 12/10/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Employee Sign Up")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Create your Disney employee account")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 32)
                    
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
                            
                            Text("Must be 10+ characters with uppercase, lowercase, number, and special character")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            SecureField("Confirm password", text: $confirmPassword)
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
                        
                        if showSuccess {
                            Text("Account created! Please check your email to verify.")
                                .font(.caption)
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Button(action: handleSignUp) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.8, green: 0.2, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(isLoading)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func handleSignUp() {
        guard validateEmail(email) else {
            errorMessage = "Please use your Disney employee email (firstname.lastname@disney.com)"
            showError = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        guard validatePassword(password) else {
            errorMessage = "Password must be 10+ characters with uppercase, lowercase, number, and special character"
            showError = true
            return
        }
        
        isLoading = true
        showError = false
        
        Task {
            do {
                try await SupabaseService.shared.signUp(email: email, password: password)
                await MainActor.run {
                    showSuccess = true
                    isLoading = false
                }
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
    
    private func validatePassword(_ password: String) -> Bool {
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        
        return password.count >= 10 && hasUppercase && hasLowercase && hasNumber && hasSpecial
    }
}
