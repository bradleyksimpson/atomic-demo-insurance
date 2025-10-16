import SwiftUI
import Foundation

// MARK: - Insurance Types
enum InsuranceType: String, CaseIterable, Identifiable {
    case house = "House"
    case contents = "Contents"
    case vehicle = "Vehicle"
    case pet = "Pet"
    case life = "Life"
    case travel = "Travel"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .house: return "house.fill"
        case .contents: return "shippingbox.fill"
        case .vehicle: return "car.fill"
        case .pet: return "pawprint.fill"
        case .life: return "heart.fill"
        case .travel: return "airplane"
        }
    }
    
    var color: Color {
        switch self {
        case .house: return .blue
        case .contents: return .orange
        case .vehicle: return .green
        case .pet: return .purple
        case .life: return .red
        case .travel: return .teal
        }
    }
}

// MARK: - Policy Model
struct Policy: Identifiable {
    let id = UUID()
    let type: InsuranceType
    let policyNumber: String
    let startDate: Date
    let endDate: Date
    let premium: Double
    let coverageAmount: Double
    let status: PolicyStatus
    let details: [String: String]
    
    enum PolicyStatus: String {
        case active = "Active"
        case pending = "Pending"
        case expired = "Expired"
        case cancelled = "Cancelled"
        
        var color: Color {
            switch self {
            case .active: return Theme.success
            case .pending: return Theme.warning
            case .expired: return Theme.textSecondary
            case .cancelled: return Theme.danger
            }
        }
    }
}

// MARK: - Claim Model
struct Claim: Identifiable {
    let id = UUID()
    let policyId: UUID
    let claimNumber: String
    let date: Date
    let type: String
    let description: String
    let amount: Double
    let status: ClaimStatus
    let photos: [String]
    
    enum ClaimStatus: String {
        case submitted = "Submitted"
        case underReview = "Under Review"
        case approved = "Approved"
        case paid = "Paid"
        case rejected = "Rejected"
        
        var color: Color {
            switch self {
            case .submitted: return Theme.info
            case .underReview: return Theme.warning
            case .approved: return Theme.success
            case .paid: return Theme.success
            case .rejected: return Theme.danger
            }
        }
    }
}

// MARK: - Telematics Data
class TelematicsData: ObservableObject {
    @Published var safetyScore: Int = 85
    @Published var totalTrips: Int = 247
    @Published var totalMiles: Double = 3421.5
    @Published var hardBrakes: Int = 3
    @Published var rapidAccelerations: Int = 7
    @Published var nightDriving: Double = 0.15
    @Published var potentialDiscount: Double = 0.25
    @Published var recentTrips: [Trip] = []
    
    struct Trip: Identifiable {
        let id = UUID()
        let date: Date
        let distance: Double
        let duration: TimeInterval
        let score: Int
        let route: String
    }
}

// MARK: - Chat Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
    let options: [ChatOption]?
    
    struct ChatOption: Identifiable {
        let id = UUID()
        let text: String
        let action: () -> Void
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var showOnboarding: Bool = false
    @Published var userPolicies: [Policy] = []
    @Published var activeClaims: [Claim] = []
    @Published var telematicsData = TelematicsData()
    @Published var chatMessages: [ChatMessage] = []
    @Published var isAuthenticated: Bool = true
    @Published var selectedPolicy: Policy?
    
    init() {
        loadSampleData()
    }
}