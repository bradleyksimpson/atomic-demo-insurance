import SwiftUI

struct PoliciesView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddPolicy = false
    @State private var selectedPolicy: Policy?
    
    // Sample policies
    @State private var policies = [
        Policy(
            type: .vehicle,
            policyNumber: "AUTO-2024-8974",
            startDate: Date().addingTimeInterval(-86400 * 180),
            endDate: Date().addingTimeInterval(86400 * 185),
            premium: 125,
            coverageAmount: 50000,
            status: .active,
            details: [
                "Vehicle": "2022 Tesla Model 3",
                "VIN": "5YJ3E1EA1MF000001",
                "Deductible": "$500",
                "Coverage": "Comprehensive"
            ]
        ),
        Policy(
            type: .house,
            policyNumber: "HOME-2024-3421",
            startDate: Date().addingTimeInterval(-86400 * 90),
            endDate: Date().addingTimeInterval(86400 * 275),
            premium: 180,
            coverageAmount: 450000,
            status: .active,
            details: [
                "Address": "123 Main St, San Francisco, CA",
                "Type": "Single Family Home",
                "Year Built": "2015",
                "Coverage": "Full Replacement"
            ]
        ),
        Policy(
            type: .pet,
            policyNumber: "PET-2024-1122",
            startDate: Date().addingTimeInterval(-86400 * 30),
            endDate: Date().addingTimeInterval(86400 * 335),
            premium: 45,
            coverageAmount: 5000,
            status: .active,
            details: [
                "Pet Name": "Max",
                "Type": "Dog - Golden Retriever",
                "Age": "3 years",
                "Coverage": "Accident & Illness"
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Coverage overview
                    coverageOverview
                    
                    // Quick actions
                    quickActions

                    // Atomic Embedded-2 Container - Policy Insights
                    #if canImport(AtomicSwiftUISDK)
                    DemoInsuranceAtomicSingleCardContainer(containerID: DemoInsuranceAtomicConfiguration.embedded2ContainerID)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, -8)
                    #else
                    InsuranceAtomicPlaceholderCard(title: "Policy Insights", subtitle: "SDK Ready: \(DemoInsuranceAtomicConfiguration.embedded2ContainerID)", icon: "📋")
                        .frame(maxWidth: .infinity)
                    #endif

                    // Active policies
                    activePoliciesSection
                    
                    // Recommendations
                    recommendationsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.backgroundGray)
            .navigationTitle("My Policies")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddPolicy) {
                AddPolicyView()
            }
            .sheet(item: $selectedPolicy) { policy in
                PolicyDetailView(policy: policy)
            }
        }
    }
    
    var coverageOverview: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Coverage")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("$\(policies.reduce(0) { $0 + Int($1.coverageAmount) }.formatted())")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Coverage score
                CircularProgressView(
                    progress: 0.85,
                    color: .white,
                    lineWidth: 8
                )
                .frame(width: 80, height: 80)
                .overlay(
                    VStack(spacing: 2) {
                        Text("85%")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text("Protected")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
            }
            
            HStack(spacing: 20) {
                CoverageStat(
                    value: "\(policies.count)",
                    label: "Active Policies",
                    icon: "doc.text.fill"
                )
                
                CoverageStat(
                    value: "$\(policies.reduce(0) { $0 + Int($1.premium) })",
                    label: "Monthly Total",
                    icon: "calendar"
                )
                
                CoverageStat(
                    value: "A+",
                    label: "Coverage Grade",
                    icon: "star.fill"
                )
            }
        }
        .padding(24)
        .background(Theme.primaryGradient)
        .cornerRadius(20)
    }
    
    var quickActions: some View {
        HStack(spacing: 12) {
            QuickActionCard(
                icon: "plus.circle.fill",
                title: "Add Policy",
                color: Theme.primaryPink
            ) {
                showAddPolicy = true
            }
            
            QuickActionCard(
                icon: "arrow.triangle.2.circlepath",
                title: "Compare",
                color: Color.blue
            ) {
                // Action
            }
            
            QuickActionCard(
                icon: "doc.on.doc.fill",
                title: "Documents",
                color: Color.orange
            ) {
                // Action
            }
        }
    }
    
    var activePoliciesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Policies")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(policies) { policy in
                PolicyCard(policy: policy) {
                    selectedPolicy = policy
                }
            }
        }
    }
    
    var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Coverage Gaps")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            CoverageGapCard(
                icon: "umbrella.fill",
                title: "Umbrella Insurance",
                description: "Add extra liability protection for just $20/month",
                color: Color.purple
            )
            
            CoverageGapCard(
                icon: "heart.text.square.fill",
                title: "Life Insurance",
                description: "Protect your family's future starting at $30/month",
                color: Color.red
            )
        }
    }
}

struct PolicyCard: View {
    let policy: Policy
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                HStack {
                    Circle()
                        .fill(policy.type.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: policy.type.icon)
                                .font(.system(size: 24))
                                .foregroundColor(policy.type.color)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(policy.type.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(policy.policyNumber)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    StatusChip(status: policy.status)
                }
                
                // Coverage details
                HStack {
                    PolicyDetail(
                        label: "Coverage",
                        value: "$\(Int(policy.coverageAmount).formatted())"
                    )
                    
                    Spacer()
                    
                    PolicyDetail(
                        label: "Premium",
                        value: "$\(Int(policy.premium))/mo"
                    )
                    
                    Spacer()
                    
                    PolicyDetail(
                        label: "Renews",
                        value: policy.endDate.formatted(date: .abbreviated, time: .omitted)
                    )
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PolicyDetail: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

struct StatusChip: View {
    let status: Policy.PolicyStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(status.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.color.opacity(0.1))
            .cornerRadius(12)
    }
}

struct CoverageStat: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
        }
    }
}

struct CoverageGapCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: progress)
        }
    }
}

// Placeholder views for sheets
struct AddPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Policy")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("New Policy")
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

struct PolicyDetailView: View {
    @Environment(\.dismiss) var dismiss
    let policy: Policy
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Policy header
                    HStack {
                        Circle()
                            .fill(policy.type.color.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: policy.type.icon)
                                    .font(.system(size: 30))
                                    .foregroundColor(policy.type.color)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(policy.type.rawValue)
                                .font(.system(size: 24, weight: .bold))
                            Text(policy.policyNumber)
                                .font(.system(size: 16))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Details
                    ForEach(Array(policy.details.keys.sorted()), id: \.self) { key in
                        HStack {
                            Text(key)
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text(policy.details[key] ?? "")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Policy Details")
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

#Preview {
    PoliciesView()
        .environmentObject(AppState())
}