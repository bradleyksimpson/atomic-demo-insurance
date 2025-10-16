import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var greeting = "Good morning"
    @State private var selectedCategory: InsuranceType?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Insurance Categories
                    categoriesSection
                    
                    // Active Policies Summary
                    if !appState.userPolicies.isEmpty {
                        activePoliciesSection
                    }
                    
                    // Atomic Single Card Container - Insurance Alerts
                    ZStack {
                        // Glass background to match design system
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white.opacity(0.6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: Theme.cardShadow, radius: 15, x: 0, y: 8)
                        
                        // Real Atomic Single Card Container
                        #if canImport(AtomicSwiftUISDK)
                        DemoInsuranceAtomicSingleCardContainer(containerID: DemoInsuranceAtomicConfiguration.embeddedContainerID)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        #else
                        InsuranceAtomicPlaceholderCard(title: "Insurance Alerts", subtitle: "SDK Ready: \(DemoInsuranceAtomicConfiguration.embeddedContainerID)", icon: "🛡️")
                        #endif
                    }
                    .frame(height: 120)
                    
                    // Recommendations
                    recommendationsSection
                    
                    // Atomic Horizontal Scroll Container - Insurance Tips
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Insurance Tips & Benefits")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            Spacer()
                            
                            Text("Container: \(DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        
                        // Real Atomic Horizontal Scroll Container
                        ZStack {
                            // Glass background maintaining design consistency
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white.opacity(0.5))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.4), lineWidth: 1)
                                )
                                .shadow(color: Theme.cardShadow, radius: 10, x: 0, y: 5)
                            
                            #if canImport(AtomicSwiftUISDK)
                            DemoInsuranceAtomicHorizontalScrollContainer(containerID: DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(4)
                            #else
                            InsuranceAtomicHorizontalPlaceholder(containerID: DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)
                            #endif
                        }
                        .frame(height: 140)
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .background(Theme.backgroundGray)
            .navigationBarHidden(true)
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                    
                    // Enhanced app name with icon and mixed typography
                    HStack(spacing: 8) {
                        // Insurance/Shield icon with glass effect
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Theme.primaryPink.opacity(0.3), lineWidth: 1.5)
                                )
                                .shadow(color: Theme.primaryPink.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "shield.checkered")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Theme.primaryPink, Theme.darkPink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .font(.system(size: 18, weight: .medium))
                        }
                        
                        // Mixed typography app name
                        HStack(spacing: 0) {
                            Text("Demo")
                                .font(.system(size: 28, weight: .regular, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                            
                            Text("Insurance")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                        }
                    }
                }
                
                Spacer()
                
                // Enhanced notification bell with glass effect
                Button(action: {}) {
                    ZStack(alignment: .topTrailing) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                        }
                        
                        Circle()
                            .fill(Theme.primaryPink)
                            .frame(width: 12, height: 12)
                            .offset(x: 6, y: -6)
                    }
                }
            }
            
            // Protection Score Card
            HStack {
                VStack(alignment: .leading) {
                    Text("Your Protection Score")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(alignment: .bottom) {
                        Text("85")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        Text("/100")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Image(systemName: "shield.checkered")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(Theme.primaryGradient)
            .cornerRadius(20)
        }
        .padding(.top)
    }
    
    var quickActionsSection: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                icon: "camera.fill",
                title: "File Claim",
                color: Theme.primaryPink
            ) {
                // Action
            }
            
            QuickActionButton(
                icon: "doc.text.fill",
                title: "Get Quote",
                color: Color.blue
            ) {
                // Action
            }
            
            QuickActionButton(
                icon: "car.fill",
                title: "Drive Score",
                color: Color.green
            ) {
                // Action
            }
            
            QuickActionButton(
                icon: "questionmark.circle.fill",
                title: "Help",
                color: Color.orange
            ) {
                // Action
            }
        }
    }
    
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What would you like to insure?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(InsuranceType.allCases) { type in
                    InsuranceCategoryCard(type: type) {
                        selectedCategory = type
                    }
                }
            }
        }
    }
    
    var activePoliciesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Active Policies")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(appState.userPolicies.prefix(2)) { policy in
                PolicySummaryCard(policy: policy)
            }
        }
    }
    
    var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations for you")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            RecommendationCard(
                title: "Bundle & Save 20%",
                subtitle: "Add home insurance to your auto policy",
                icon: "percent",
                color: Theme.success
            )
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(color)
                    )
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

struct InsuranceCategoryCard: View {
    let type: InsuranceType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Circle()
                    .fill(type.color.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: type.icon)
                            .font(.system(size: 28))
                            .foregroundColor(type.color)
                    )
                
                Text(type.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
        }
    }
}

struct PolicySummaryCard: View {
    let policy: Policy
    
    var body: some View {
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
                Text("\(policy.type.rawValue) Insurance")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(policy.policyNumber)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(policy.status.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(policy.status.color)
                
                Text("$\(Int(policy.premium))/mo")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .padding()
        .cardStyle()
    }
}

struct RecommendationCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
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
        .cardStyle()
    }
}

// MARK: - Atomic Placeholder Components for Demo Insurance
struct InsuranceAtomicPlaceholderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Icon with glass effect
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Theme.primaryPink.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: Theme.primaryPink.opacity(0.2), radius: 6, x: 0, y: 3)
                    
                    Text(icon)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Text("SDK Ready")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.green.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.6))
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.primaryPink.opacity(0.02))
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
        )
        .shadow(color: .black.opacity(0.06), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
}

struct InsuranceAtomicHorizontalPlaceholder: View {
    let containerID: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Insurance Tips & Benefits")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Text("Container: \(containerID)")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        InsuranceTipCard(
                            title: ["Policy Bundle", "Safety Discounts", "Quick Claims"][index],
                            content: ["Save 20% bundling", "Lower rates for safe driving", "File claims in minutes"][index],
                            icon: ["📋", "🚗", "📱"][index]
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct InsuranceTipCard: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 28))
            
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Theme.primaryPink)
                .multilineTextAlignment(.center)
            
            Text(content)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 200, height: 140)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.primaryPink.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}