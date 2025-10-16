import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    let onboardingData = [
        OnboardingPage(
            title: "Welcome to Demo Insurance",
            subtitle: "Insurance made delightfully simple",
            image: "shield.fill",
            color: Theme.primaryPink
        ),
        OnboardingPage(
            title: "AI-Powered Experience",
            subtitle: "Get quotes in seconds with our smart assistant",
            image: "brain",
            color: Color.purple
        ),
        OnboardingPage(
            title: "Drive & Save",
            subtitle: "Safe drivers earn up to 40% discount",
            image: "car.fill",
            color: Color.green
        ),
        OnboardingPage(
            title: "Instant Claims",
            subtitle: "Snap a photo, get paid in minutes",
            image: "camera.fill",
            color: Color.blue
        )
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .foregroundColor(Theme.textSecondary)
                    .padding()
                }
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Theme.primaryPink : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeOut, value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                // Continue button
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        currentPage += 1
                    } else {
                        completeOnboarding()
                    }
                }) {
                    Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Continue")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation(.spring()) {
            appState.showOnboarding = false
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: page.image)
                    .font(.system(size: 80))
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 17))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}