import Foundation
import UIKit
import SwiftUI

// Conditional imports - only when SDK is actually added
#if canImport(AtomicSDK)
import AtomicSDK
#endif

#if canImport(AtomicSwiftUISDK)
import AtomicSwiftUISDK
#endif

// MARK: - Atomic Configuration for Demo Insurance
struct DemoInsuranceAtomicConfiguration {
    // Atomic Workbench Details
    static let organizationID = "512-1"
    static let environmentID = "BJelgDpV"
    static let apiHost = "https://512-1.customer-api.atomic.io"
    static let hostUrl = "\(apiHost)/\(environmentID)"
    
    // API Credentials - Demo Insurance Environment
    static let eventsClientID = "3b0qbg8r4854h0solt0r7s169t"
    static let eventsClientSecret = "1o6k4eajjrtr2qmdkcfgd826517vh8cqml90tadu1lna5bpjinki"
    
    // Demo Insurance JWT Authentication API Key
    static let jwtAPIKey = "demo-insurance-app-jwt"
    static let currentAPIKey = jwtAPIKey
    
    // Container IDs from container_id_512-1_BJelgDpV_Insurance.csv
    static let overlayContainerID = "5GdbeglB"           // OverlayActive - Modal overlay
    static let messageCenterContainerID = "Wm2PoYzK"    // Message_CenterActive for notifications
    static let toastContainerID = "Zzeb10GQ"            // ToastActive for temporary alerts
    static let horizontalScrollContainerID = "KzRRBDzJ" // Horizontal_ScrollActive for featured content
    static let embedded3ContainerID = "1zyjOLGx"        // Embedded-3Active for additional content
    static let embedded2ContainerID = "Rm0QZklj"        // Embedded-2Active for secondary content  
    static let embeddedContainerID = "5zg5kRmX"         // EmbeddedActive for main dashboard
    static let defaultContainerID = "nloaReG0"          // DefaultActive container
    
    // Demo Insurance branding configuration
    static let brandColors = AtomicBrandColors(
        primary: UIColor(red: 0.91, green: 0.20, blue: 0.46, alpha: 1.0), // Insurance Pink
        secondary: UIColor(red: 0.12, green: 0.47, blue: 0.85, alpha: 1.0), // Insurance Blue
        background: UIColor.systemBackground,
        surface: UIColor.secondarySystemBackground
    )
    
    // PERFORMANCE: Shared pre-computed configuration objects
    static let sharedSingleCardConfig: AACSingleCardConfiguration = {
        let config = AACSingleCardConfiguration()
        config.automaticallyLoadNextCard = true
        config.launchBackgroundColor = brandColors.background
        config.launchTextColor = brandColors.primary
        config.launchLoadingIndicatorColor = brandColors.secondary
        return config
    }()
    
    static let sharedStreamConfig: AACConfiguration = {
        let config = AACConfiguration()
        config.launchBackgroundColor = brandColors.background
        config.launchTextColor = brandColors.primary
        config.launchLoadingIndicatorColor = brandColors.secondary
        return config
    }()
    
    static let sharedHorizontalConfig: AACHorizontalContainerConfiguration = {
        let config = AACHorizontalContainerConfiguration()
        config.cardWidth = 360
        config.scrollMode = .snap
        config.launchBackgroundColor = UIColor.white
        config.launchTextColor = brandColors.primary
        config.launchLoadingIndicatorColor = brandColors.secondary
        return config
    }()
}

// MARK: - Demo Insurance Atomic Integration Manager
class DemoInsuranceAtomicIntegrationManager: ObservableObject {
    static let shared = DemoInsuranceAtomicIntegrationManager()
    
    // Session delegate for authentication
    let sessionDelegate = DemoInsuranceAtomicSessionDelegate()
    
    private init() {
        configureAtomicSDK()
    }
    
    private func configureAtomicSDK() {
        print("🔧 Demo Insurance Atomic SDK Configuration")
        print("🏢 Organization ID: \(DemoInsuranceAtomicConfiguration.organizationID)")
        print("🌐 Environment ID: \(DemoInsuranceAtomicConfiguration.environmentID)")
        print("🌍 API Host: \(DemoInsuranceAtomicConfiguration.apiHost)")
        
        validateContainerConfiguration()
    }
    
    private func validateContainerConfiguration() {
        print("🔍 DEMO INSURANCE CONTAINER VALIDATION:")
        
        let containers = [
            ("Overlay", DemoInsuranceAtomicConfiguration.overlayContainerID),
            ("Message Center", DemoInsuranceAtomicConfiguration.messageCenterContainerID),
            ("Toast", DemoInsuranceAtomicConfiguration.toastContainerID),
            ("Horizontal Scroll", DemoInsuranceAtomicConfiguration.horizontalScrollContainerID),
            ("Embedded-3", DemoInsuranceAtomicConfiguration.embedded3ContainerID),
            ("Embedded-2", DemoInsuranceAtomicConfiguration.embedded2ContainerID),
            ("Embedded", DemoInsuranceAtomicConfiguration.embeddedContainerID),
            ("Default", DemoInsuranceAtomicConfiguration.defaultContainerID)
        ]
        
        for (name, id) in containers {
            let status = validateContainerID(id)
            let statusIcon = status ? "✅" : "❌"
            print("   \(statusIcon) \(name): '\(id)' (Length: \(id.count), Valid: \(status))")
        }
    }
    
    private func validateContainerID(_ containerID: String) -> Bool {
        let isValid = !containerID.isEmpty && 
                     containerID.count >= 6 && 
                     containerID.count <= 12 &&
                     containerID.allSatisfy { $0.isLetter || $0.isNumber }
        return isValid
    }
    
    // MARK: - Container Configuration Methods
    func configureSingleCardContainer() -> UIView {
        print("🃏 Configuring Demo Insurance Single Card Container: \(DemoInsuranceAtomicConfiguration.embeddedContainerID)")
        
        let singleCardView = AACSingleCardView(
            frame: .zero,
            containerIdentifier: DemoInsuranceAtomicConfiguration.embeddedContainerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedSingleCardConfig
        )
        
        return singleCardView
    }
    
    func configureStreamContainer() -> UIView {
        print("📱 Configuring Demo Insurance Stream Container: \(DemoInsuranceAtomicConfiguration.messageCenterContainerID)")
        
        let streamContainer = AACStreamContainerViewController(
            identifier: DemoInsuranceAtomicConfiguration.messageCenterContainerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedStreamConfig
        )
        
        _ = streamContainer.view
        return streamContainer.view
    }
    
    func configureHorizontalScrollContainer() -> UIView {
        print("↔️ Configuring Demo Insurance Horizontal Scroll Container: \(DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)")
        
        let horizontalView = AACHorizontalContainerView(
            frame: .zero,
            containerIdentifier: DemoInsuranceAtomicConfiguration.horizontalScrollContainerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedHorizontalConfig
        )
        
        return horizontalView
    }
}

// MARK: - SwiftUI Integration Wrappers for Demo Insurance
struct DemoInsuranceAtomicSingleCardContainer: UIViewRepresentable {
    let containerID: String
    
    func makeUIView(context: Context) -> UIView {
        print("🔄 Creating Demo Insurance SingleCardContainer")
        print("🎯 Container ID: \(containerID)")
        
        let singleCardView = AACSingleCardView(
            frame: .zero,
            containerIdentifier: containerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedSingleCardConfig
        )
        
        singleCardView.accessibilityIdentifier = "demo-insurance-single-card"
        singleCardView.accessibilityLabel = "Insurance Alert Card"
        
        return singleCardView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Minimal update - let container manage its own state
    }
}

struct DemoInsuranceAtomicStreamContainer: UIViewControllerRepresentable {
    let containerID: String
    
    func makeUIViewController(context: Context) -> AACStreamContainerViewController {
        print("🔄 Creating Demo Insurance StreamContainer")
        print("🎯 Container ID: \(containerID)")
        
        let streamContainer = AACStreamContainerViewController(
            identifier: containerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedStreamConfig
        )
        
        return streamContainer
    }
    
    func updateUIViewController(_ uiViewController: AACStreamContainerViewController, context: Context) {
        // Minimal update - let container manage its own content
    }
}

struct DemoInsuranceAtomicHorizontalScrollContainer: UIViewRepresentable {
    let containerID: String
    
    func makeUIView(context: Context) -> UIView {
        print("🔄 Creating Demo Insurance HorizontalContainer")
        print("🎯 Container ID: \(containerID)")
        
        let horizontalView = AACHorizontalContainerView(
            frame: .zero,
            containerIdentifier: containerID,
            configuration: DemoInsuranceAtomicConfiguration.sharedHorizontalConfig
        )
        
        horizontalView.accessibilityIdentifier = "demo-insurance-horizontal-scroll"
        horizontalView.accessibilityLabel = "Insurance Content"
        
        return horizontalView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Minimal update - let container manage its own state
    }
}

struct AtomicBrandColors {
    let primary: UIColor
    let secondary: UIColor
    let background: UIColor
    let surface: UIColor
}