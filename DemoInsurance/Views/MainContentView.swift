import SwiftUI

// Conditional imports - only when SDK is actually added
#if canImport(AtomicSwiftUISDK)
import AtomicSwiftUISDK
#endif

#if canImport(AtomicSDK)
import AtomicSDK
#endif

// MARK: - Atomic ViewModel for Toast State and Message Badge
class AtomicViewModel: ObservableObject {
    @Published var showToast = false
    @Published var toastCardCount = 0
    @Published var messageCount = 0

    private var toastObserverToken: NSObjectProtocol?
    private var messageObserverToken: NSObjectProtocol?

    init() {
        setupToastObserver()
        setupMessageObserver()
    }

    private func setupToastObserver() {
        #if canImport(AtomicSDK)
        // Observe toast container card count (Otago pattern)
        toastObserverToken = AACSession.observeCardCountForStreamContainer(
            withIdentifier: DemoInsuranceAtomicConfiguration.toastContainerID,
            interval: 30
        ) { count in
            if let count = count {
                DispatchQueue.main.async {
                    let cardCount = Int(truncating: count)
                    self.toastCardCount = cardCount
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.showToast = cardCount > 0
                    }
                }
            }
        }
        #endif
    }

    private func setupMessageObserver() {
        #if canImport(AtomicSDK)
        // Observe message center container for badge count (Otago pattern)
        messageObserverToken = AACSession.observeCardCountForStreamContainer(
            withIdentifier: DemoInsuranceAtomicConfiguration.messageCenterContainerID,
            interval: 20
        ) { count in
            if let count = count {
                DispatchQueue.main.async {
                    self.messageCount = Int(truncating: count)
                    print("📬 Demo Insurance - Messages badge updated: \(self.messageCount) cards")
                }
            }
        }
        #endif
    }

    deinit {
        if let token = toastObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = messageObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var atomicViewModel = AtomicViewModel()
    @State private var selectedTab = 0

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

                InsuranceMessagesView()
                    .tabItem {
                        Label("Messages", systemImage: "message.fill")
                    }
                    .badge(atomicViewModel.messageCount)
                    .tag(4)
            }
            .accentColor(Theme.primaryPink)
        }
        .sheet(isPresented: $atomicViewModel.showToast) {
            // Toast Container - Bottom sheet like Otago app
            InsuranceToastSheetView(containerID: DemoInsuranceAtomicConfiguration.toastContainerID, brandColor: "#34C759")
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
        // CRITICAL: Add modal container for overlay cards (following Demo Power pattern)
        #if canImport(AtomicSwiftUISDK)
        .modalContainer(containerId: DemoInsuranceAtomicConfiguration.overlayContainerID)
        #endif
    }
}

// MARK: - Toast Sheet View (Otago Pattern)

struct InsuranceToastSheetView: View {
    let containerID: String
    let brandColor: String

    var body: some View {
        ZStack {
            Color(hex: brandColor)
                .ignoresSafeArea(.all)

            VStack(spacing: 0) {
                Spacer().frame(height: 40) // 25 original + 15 requested

                #if canImport(AtomicSwiftUISDK)
                SingleCardContainer(
                    containerId: containerID,
                    configuration: getToastConfig()
                )
                .frame(height: 240)
                .cornerRadius(16)
                .padding(.horizontal, 16)
                #else
                Text("Toast Container: \(containerID)")
                    .foregroundColor(.white)
                    .frame(height: 240)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                #endif

                Spacer()
            }
        }
    }

    #if canImport(AtomicSwiftUISDK)
    private func getToastConfig() -> ContainerConfiguration {
        var config = ContainerConfiguration()
        config.enabledUIElements = []
        config.setCustomValue("", for: .toastCardCompletedMessage)
        config.ignoresSafeAreaEdges = [.bottom]
        return config
    }
    #endif
}

// MARK: - Insurance Messages View
struct InsuranceMessagesView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Custom header - half height with title
            VStack(spacing: 0) {
                Text("Messages")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)

            // Messages container
            #if canImport(AtomicSwiftUISDK)
            StreamContainer(
                containerId: DemoInsuranceAtomicConfiguration.messageCenterContainerID,
                configuration: getMessageConfig()
            )
            #else
            VStack {
                Text("Messages Placeholder")
                    .font(.title)
                Text("Container: \(DemoInsuranceAtomicConfiguration.messageCenterContainerID)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            #endif
        }
        .background(Theme.backgroundGray)
    }

    #if canImport(AtomicSwiftUISDK)
    private func getMessageConfig() -> ContainerConfiguration {
        var config = ContainerConfiguration()
        config.enabledUIElements = []
        config.setCustomValue("", for: .toastCardCompletedMessage)
        return config
    }
    #endif
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MainContentView()
        .environmentObject(AppState())
}