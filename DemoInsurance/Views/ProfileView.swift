import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false
    @State private var showNotificationSettings = false
    @State private var showMessageHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    profileHeader
                    
                    // Loyalty/rewards section
                    loyaltySection
                    
                    // Quick settings
                    quickSettingsSection
                    
                    // Smart home devices
                    smartHomeSection
                    
                    // Account actions
                    accountActionsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.backgroundGray)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showMessageHistory) {
                MessageHistoryView()
            }
        }
    }
    
    var profileHeader: some View {
        VStack(spacing: 20) {
            // Profile picture
            ZStack {
                Circle()
                    .fill(Theme.primaryGradient)
                    .frame(width: 100, height: 100)
                
                Text("JD")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("John Doe")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("Member since 2022")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
            }
            
            // Member status
            HStack(spacing: 20) {
                MemberStat(value: "Gold", label: "Status")
                MemberStat(value: "3", label: "Years")
                MemberStat(value: "$2,450", label: "Saved")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }
    
    var loyaltySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rewards & Benefits")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 0) {
                RewardRow(
                    icon: "gift.fill",
                    title: "Birthday Discount",
                    subtitle: "Get 10% off your next renewal",
                    color: Theme.primaryPink
                )
                
                Divider()
                
                RewardRow(
                    icon: "percent",
                    title: "Multi-Policy Discount",
                    subtitle: "Save 15% with 3+ policies",
                    color: Color.green
                )
                
                Divider()
                
                RewardRow(
                    icon: "star.fill",
                    title: "Loyalty Points",
                    subtitle: "1,250 points available",
                    color: Color.orange
                )
            }
            .background(Color.white)
            .cornerRadius(16)
        }
    }
    
    var quickSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Settings")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 12) {
                SettingRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    value: "On"
                ) {
                    showNotificationSettings = true
                }
                
                SettingRow(
                    icon: "faceid",
                    title: "Face ID",
                    value: "Enabled"
                ) {
                    // Toggle Face ID
                }
                
                SettingRow(
                    icon: "location.fill",
                    title: "Location Tracking",
                    value: "While Driving"
                ) {
                    // Location settings
                }
            }
        }
    }
    
    var smartHomeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Connected Devices")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Button("Add Device") {
                    // Add device
                }
                .font(.system(size: 14))
                .foregroundColor(Theme.primaryPink)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    DeviceCard(
                        icon: "sensor.fill",
                        name: "Water Sensor",
                        status: "Active",
                        room: "Basement"
                    )
                    
                    DeviceCard(
                        icon: "smoke.fill",
                        name: "Smoke Detector",
                        status: "Active",
                        room: "Kitchen"
                    )
                    
                    DeviceCard(
                        icon: "lock.fill",
                        name: "Smart Lock",
                        status: "Active",
                        room: "Front Door"
                    )
                    
                    DeviceCard(
                        icon: "video.fill",
                        name: "Security Camera",
                        status: "Active",
                        room: "Driveway"
                    )
                }
            }
        }
    }
    
    var accountActionsSection: some View {
        VStack(spacing: 12) {
            AccountActionRow(
                icon: "clock.arrow.circlepath",
                title: "Message History",
                color: Theme.primaryPink
            ) {
                showMessageHistory = true
            }

            AccountActionRow(
                icon: "doc.text.fill",
                title: "Policy Documents",
                color: Color.blue
            )
            
            AccountActionRow(
                icon: "creditcard.fill",
                title: "Payment Methods",
                color: Color.green
            )
            
            AccountActionRow(
                icon: "person.2.fill",
                title: "Refer a Friend",
                color: Theme.primaryPink
            )
            
            AccountActionRow(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                color: Color.orange
            )
            
            AccountActionRow(
                icon: "gearshape.fill",
                title: "Settings",
                color: Color.gray
            ) {
                showSettings = true
            }
        }
    }
}

struct MemberStat: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.primaryPink)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RewardRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Theme.primaryPink)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct DeviceCard: View {
    let icon: String
    let name: String
    let status: String
    let room: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Theme.primaryPink)
                
                Spacer()
                
                Circle()
                    .fill(Theme.success)
                    .frame(width: 8, height: 8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(room)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .frame(width: 140)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
    }
}

struct AccountActionRow: View {
    let icon: String
    let title: String
    let color: Color
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(color)
                    )
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct MessageHistoryView: View {
    @Environment(\.dismiss) var dismiss

    private let historyContainerID = DemoInsuranceAtomicConfiguration.historyContainerID

    var body: some View {
        NavigationView {
            DemoInsuranceAtomicStreamContainer(containerID: historyContainerID)
                .ignoresSafeArea(edges: .bottom)
                .background(Theme.backgroundGray)
                .navigationTitle("Message History")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(Theme.primaryPink)
                    }
                }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Account") {
                    SettingsRowSimple(title: "Personal Information")
                    SettingsRowSimple(title: "Security")
                    SettingsRowSimple(title: "Privacy")
                }
                
                Section("Preferences") {
                    SettingsRowSimple(title: "Notifications")
                    SettingsRowSimple(title: "App Preferences")
                    SettingsRowSimple(title: "Data Usage")
                }
                
                Section("About") {
                    SettingsRowSimple(title: "Terms of Service")
                    SettingsRowSimple(title: "Privacy Policy")
                    SettingsRowSimple(title: "Version 1.0.0")
                }
                
                Section {
                    Button("Sign Out") {
                        // Sign out action
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsRowSimple: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}