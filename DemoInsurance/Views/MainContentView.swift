import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var showChatbot = false
    
    var body: some View {
        ZStack {
            if appState.showOnboarding {
                OnboardingView()
            } else {
                mainContent
            }
        }
    }
    
    var mainContent: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                PoliciesView()
                    .tabItem {
                        Label("Policies", systemImage: "doc.text.fill")
                    }
                    .tag(1)
                
                ClaimsView()
                    .tabItem {
                        Label("Claims", systemImage: "exclamationmark.circle.fill")
                    }
                    .tag(2)
                
                TelematicsView()
                    .tabItem {
                        Label("Drive", systemImage: "car.fill")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(4)
            }
            .accentColor(Theme.primaryPink)
            
            // Floating AI Assistant Button
            HStack {
                Spacer()
                Button(action: { showChatbot.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Theme.primaryGradient)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "message.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .shadow(color: Theme.primaryPink.opacity(0.3), radius: 8, x: 0, y: 4)
                .padding(.trailing, 20)
                .padding(.bottom, 90)
            }
        }
        .sheet(isPresented: $showChatbot) {
            ChatbotView()
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(AppState())
}