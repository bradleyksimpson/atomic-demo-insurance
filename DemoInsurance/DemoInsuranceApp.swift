import SwiftUI

// Conditional imports for Atomic SDK
#if canImport(AtomicSDK)
import AtomicSDK
#endif

#if canImport(AtomicSwiftUISDK)
import AtomicSwiftUISDK
#endif

@main
struct DemoInsuranceApp: App {
    @StateObject private var appState = AppState()

    init() {
        // Initialize Atomic SDK when available
        initializeAtomicSDK()
    }

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(appState)
        }
    }

    private func initializeAtomicSDK() {
        print("🚀 Demo Insurance: Initializing Atomic SDK...")

        #if canImport(AtomicSDK)
        // Enable debug mode for detailed logging
        AACSession.enableDebugMode(2)
        print("🐛 Demo Insurance: Debug mode enabled (level 2)")

        // Real Atomic SDK initialization when SDK is available
        // Using login() method - matches working Demo Power pattern
        let atomicDelegate = DemoInsuranceAtomicSessionDelegate()
        AACSession.login(
            withEnvironmentId: DemoInsuranceAtomicConfiguration.environmentID,
            apiKey: DemoInsuranceAtomicConfiguration.jwtAPIKey,
            sessionDelegate: atomicDelegate,
            apiBaseUrl: URL(string: "https://512-1.client-api.atomic.io")
        )

        print("✅ Demo Insurance: Atomic SDK initialized successfully with login()")
        print("📡 Demo Insurance: API Base URL: https://512-1.client-api.atomic.io")
        print("🔧 Environment: \(DemoInsuranceAtomicConfiguration.environmentID)")
        print("🔑 API Key: \(DemoInsuranceAtomicConfiguration.jwtAPIKey)")
        print("🎯 Containers: 8 configured and ready")
        #else
        // Placeholder mode when SDK is not available
        print("⚠️  Demo Insurance: Atomic SDK not found - running in placeholder mode")
        print("📋 To add real SDK: File → Add Package Dependencies in Xcode")
        print("📋 SDK URL: https://github.com/atomic-app/action-cards-swiftui-sdk-releases")
        print("📋 To complete setup: Add Configuration folder files to Xcode target")
        #endif
    }
}