import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: InsuranceType?
    @State private var shieldPressed = false
    @State private var shieldScale: CGFloat = 1.0
    @State private var longPressProgress: CGFloat = 0.0
    @State private var showSuccessFeedback = false
    @State private var isLongPressing = false
    
    var body: some View {
        let purple = Color(red: 174/255, green: 19/255, blue: 1)
        return NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Protection Score Card (first item in scroll content)
                    protectionScoreCard
                        .padding(.top, 8)

                    // Quick Actions
                    quickActionsSection

                    // Insurance Categories
                    categoriesSection

                    // Atomic Single Card Container - Insurance Alerts
                    // Uses consistent alignment with surrounding content (following Demo Power pattern)
                    #if canImport(AtomicSwiftUISDK)
                    DemoInsuranceAtomicSingleCardContainer(containerID: DemoInsuranceAtomicConfiguration.embeddedContainerID)
                        .insuranceContainerAlignment()
                    #else
                    InsuranceAtomicPlaceholderCard(title: "Insurance Alerts", subtitle: "SDK Ready: \(DemoInsuranceAtomicConfiguration.embeddedContainerID)", icon: "🛡️")
                        .frame(maxWidth: .infinity)
                    #endif

                    // Active Policies Summary
                    if !appState.userPolicies.isEmpty {
                        activePoliciesSection
                    }

                    // Recommendations
                    recommendationsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.backgroundGray)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .top, spacing: 0) {
                stickyHeader(purple: purple)
            }
        }
    }

    private func stickyHeader(purple: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                // Enhanced app name with icon and mixed typography - Long press trigger area
                HStack(spacing: 8) {
                    // Insurance/Shield icon with glass effect + long press custom event
                    ZStack {
                        // Progress ring during long press
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 42, height: 42)

                        Circle()
                            .trim(from: 0, to: longPressProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 42, height: 42)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.1), value: longPressProgress)

                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(shieldPressed ? Color.white : Color.white.opacity(0.5), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)

                        // Success checkmark overlay
                        if showSuccessFeedback {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .green.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .font(.system(size: 24, weight: .bold))
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Image(systemName: "shield.checkered")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                    .scaleEffect(shieldScale)
                    .animation(.spring(duration: 0.3, bounce: 0.5), value: shieldScale)
                    .animation(.easeInOut(duration: 0.3), value: shieldPressed)
                    .animation(.spring(duration: 0.4, bounce: 0.6), value: showSuccessFeedback)

                    // Mixed typography app name
                    HStack(spacing: 0) {
                        Text("Demo")
                            .font(.system(size: 28, weight: .regular, design: .rounded))
                            .foregroundColor(.white)

                        Text("Insurance")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .contentShape(Rectangle())
                .onLongPressGesture(minimumDuration: 2.0, pressing: { pressing in
                    if pressing {
                        // User started pressing
                        handleLongPressStart()
                    } else {
                        // User lifted finger before completion
                        if isLongPressing {
                            cancelLongPress()
                        }
                    }
                }, perform: {
                    // Long press completed successfully
                    handleShieldLongPress()
                })
            }

            Spacer()

            // Profile avatar button
            NavigationLink(destination: ProfileView()) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Profile avatar
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .background(purple.ignoresSafeArea(edges: .top))
    }

    var protectionScoreCard: some View {
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

    // MARK: - Custom Event Handlers

    /// Handles long press start - begins progress animation and haptic feedback
    private func handleLongPressStart() {
        print("🔄 Long press started")
        isLongPressing = true

        // Initial haptic feedback - light impact when press begins
        let lightFeedback = UIImpactFeedbackGenerator(style: .light)
        lightFeedback.prepare()
        lightFeedback.impactOccurred()

        // Start visual feedback
        withAnimation(.easeInOut(duration: 0.2)) {
            shieldScale = 1.1
            shieldPressed = true
        }

        // Animate progress ring over 2 seconds
        withAnimation(.linear(duration: 2.0)) {
            longPressProgress = 1.0
        }

        // Mid-press haptic feedback at 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.isLongPressing {
                let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
                mediumFeedback.prepare()
                mediumFeedback.impactOccurred()
            }
        }
    }

    /// Cancels long press if user drags away
    private func cancelLongPress() {
        print("❌ Long press cancelled")
        isLongPressing = false

        // Reset animations
        withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
            longPressProgress = 0.0
            shieldScale = 1.0
            shieldPressed = false
        }
    }

    /// Handles shield icon long press completion - sends custom event to Atomic SDK
    /// Follows Demo Uni and Demo Power pattern with enhanced visual and haptic feedback
    private func handleShieldLongPress() {
        guard isLongPressing else { return }

        print("🔄 Shield long press completed")
        isLongPressing = false

        // Completion haptic feedback - heavy impact for success
        let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
        heavyFeedback.prepare()
        heavyFeedback.impactOccurred()

        // Visual feedback - completion pulse
        withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
            shieldScale = 1.3
        }

        // Send custom event to Atomic SDK
        #if canImport(AtomicSDK)
        DemoInsuranceAtomicIntegrationManager.sendResetInsuranceEvent { success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ Reset insurance event sent successfully")

                    // Success haptic feedback
                    let successFeedback = UINotificationFeedbackGenerator()
                    successFeedback.prepare()
                    successFeedback.notificationOccurred(.success)

                    // Show success checkmark
                    withAnimation(.spring(duration: 0.4, bounce: 0.6)) {
                        self.showSuccessFeedback = true
                        self.shieldScale = 1.2
                    }

                    // Hide success feedback and reset after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                            self.showSuccessFeedback = false
                            self.shieldPressed = false
                            self.shieldScale = 1.0
                            self.longPressProgress = 0.0
                        }
                    }
                } else {
                    print("❌ Failed to send reset insurance event: \(error ?? "unknown error")")

                    // Error haptic feedback
                    let errorFeedback = UINotificationFeedbackGenerator()
                    errorFeedback.prepare()
                    errorFeedback.notificationOccurred(.error)

                    // Reset with error state
                    withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                        self.shieldPressed = false
                        self.shieldScale = 1.0
                        self.longPressProgress = 0.0
                    }
                }
            }
        }
        #else
        print("⚠️ AtomicSDK not available - event not sent")

        // Reset without SDK
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                self.shieldPressed = false
                self.shieldScale = 1.0
                self.longPressProgress = 0.0
            }
        }
        #endif
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