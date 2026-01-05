# Disney VIP App (Mobile)

A SwiftUI-based iOS application designed to simulate a VIP-style guest experience management system. The app focuses on authentication, reservations, events, and check-ins, built with a modern MVVM architecture and a scalable backend integration.

> ⚠️ **Disclaimer:**  
> This project is a personal, non-commercial portfolio application and is **not affiliated with, endorsed by, or associated with The Walt Disney Company** or any of its subsidiaries. All names and concepts are used strictly for educational and demonstrative purposes.

---

## ✨ Features

- 🔐 User Authentication (Login / Sign Up)
- 📅 Reservation creation and management
- 🎟️ Event listings and detail views
- ✅ Guest check-in tracking
- 📊 Dashboard overview
- ⚙️ User settings and profile management
- 🧭 Tab-based navigation using SwiftUI

---

## 🛠️ Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **Backend / Services:** Supabase
- **Package Management:** Swift Package Manager (SPM)
- **Platform:** iOS

---

## 📂 Project Structure

VIPmobile/
├── Models/
│ ├── User.swift
│ ├── Reservation.swift
│ ├── Event.swift
│ └── CheckIn.swift
│
├── ViewModels/
│ └── AuthenticationManager.swift
│
├── Services/
│ └── SupabaseService.swift
│
├── Views/
│ ├── LoginView.swift
│ ├── SignUpView.swift
│ ├── MainTabView.swift
│ ├── DashboardView.swift
│ ├── EventListView.swift
│ ├── EventDetailView.swift
│ ├── NewReservationView.swift
│ └── SettingsView.swift
│
└── VIPmobileApp.swift
---

## 🚀 Getting Started

### Prerequisites
- macOS
- Xcode 15+
- iOS Simulator or physical device
- Supabase project (for backend functionality)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/JoshuaKhooba/Disney-VIP-App.git

2. Open the project:

    open VIPmobile.xcodeproj

3. Configure your Supabase credentials (recommended via environment variables).

4. Build and run the project in Xcode.

🔐 Environment Configuration

For security reasons, API keys and secrets should not be committed.

Recommended:

Store keys in environment variables or a local .env file

Ensure .env is listed in .gitignore

🧭 Roadmap

Improve reservation conflict handling

Role-based access (admin vs guest)

Push notifications

Offline support

UI polish & animations

Unit and UI tests

📸 Screenshots

(Coming soon)

👤 Author

Joshua Khooba
Computer Science Graduate | Data Analytics & Full-Stack Developer

📄 License

This project is licensed under the MIT License — see the LICENSE file for details.
