import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    // Sample policies
    static let samplePolicies = [
        Policy(
            type: .vehicle,
            policyNumber: "AUTO-2024-8974",
            startDate: Date().addingTimeInterval(-86400 * 180),
            endDate: Date().addingTimeInterval(86400 * 185),
            premium: 125,
            coverageAmount: 50000,
            status: .active,
            details: [
                "Vehicle": "2023 Tesla Model Y",
                "VIN": "5YJYGDEE1NF000001",
                "Deductible": "$500",
                "Coverage": "Comprehensive + Collision",
                "Annual Mileage": "12,000 miles"
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
                "Address": "123 Maple Street, San Francisco, CA 94102",
                "Type": "Single Family Home",
                "Year Built": "2018",
                "Square Footage": "2,400 sq ft",
                "Deductible": "$1,000"
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
                "Pet Name": "Luna",
                "Breed": "Golden Retriever",
                "Age": "3 years",
                "Coverage": "Accident & Illness",
                "Deductible": "$250"
            ]
        )
    ]
    
    // Sample claims
    static let sampleClaims = [
        Claim(
            policyId: UUID(),
            claimNumber: "CLM-2024-0142",
            date: Date().addingTimeInterval(-86400 * 3),
            type: "Auto Collision",
            description: "Minor fender bender in grocery store parking lot. Rear bumper damage.",
            amount: 2500,
            status: .underReview,
            photos: ["damage1.jpg", "damage2.jpg"]
        ),
        
        Claim(
            policyId: UUID(),
            claimNumber: "CLM-2024-0089",
            date: Date().addingTimeInterval(-86400 * 45),
            type: "Home - Water Damage",
            description: "Kitchen sink leak caused water damage to hardwood floors.",
            amount: 4200,
            status: .paid,
            photos: ["water_damage1.jpg", "water_damage2.jpg", "water_damage3.jpg"]
        )
    ]
    
    // Sample telematics trips
    static let sampleTrips = [
        TelematicsData.Trip(
            date: Date(),
            distance: 15.3,
            duration: 1200, // 20 minutes
            score: 92,
            route: "Home → Office"
        ),
        
        TelematicsData.Trip(
            date: Date().addingTimeInterval(-86400),
            distance: 28.7,
            duration: 2100, // 35 minutes
            score: 88,
            route: "Office → Grocery Store → Home"
        ),
        
        TelematicsData.Trip(
            date: Date().addingTimeInterval(-86400 * 2),
            distance: 42.1,
            duration: 3600, // 60 minutes
            score: 85,
            route: "Weekend Trip to Beach"
        ),
        
        TelematicsData.Trip(
            date: Date().addingTimeInterval(-86400 * 3),
            distance: 8.2,
            duration: 900, // 15 minutes
            score: 95,
            route: "Home → Coffee Shop"
        )
    ]
    
    // Insurance quotes for different types
    static let quoteResponses = [
        "house": [
            "Great! For a home in San Francisco, I can offer you comprehensive coverage starting at $180/month.",
            "Based on your zip code, here's what we found: Full replacement coverage for $165/month with smart home discounts available.",
            "Your home qualifies for our premium protection plan at $195/month, including earthquake coverage."
        ],
        
        "car": [
            "Perfect! For your vehicle, we can offer full coverage starting at $125/month with our safe driver discount.",
            "Based on your driving record, here's a great rate: Comprehensive coverage for just $110/month!",
            "Your car qualifies for our telematics program - drive safe and save up to 40%! Starting at $135/month."
        ],
        
        "pet": [
            "Wonderful! Pet insurance for your furry friend starts at just $45/month with 90% coverage.",
            "Great choice! Comprehensive pet coverage including accidents and illness for $52/month.",
            "Your pet qualifies for our wellness plan at $38/month with routine care included."
        ]
    ]
    
    // Smart home device recommendations
    static let deviceRecommendations = [
        "Installing a water leak detector could reduce your home insurance by 8%",
        "Security cameras can lower your premium by up to 15%",
        "Smart smoke detectors qualify for a 5% safety discount",
        "A smart thermostat prevents frozen pipes and saves 10% on premiums"
    ]
    
    // Risk assessment tips
    static let riskTips = [
        RiskTip(
            category: "Home",
            title: "Prevent Water Damage",
            description: "Check your water heater annually and replace hoses every 5 years",
            impact: "Reduces claims by 23%"
        ),
        
        RiskTip(
            category: "Auto",
            title: "Defensive Driving",
            description: "Maintain 3-second following distance and avoid night driving when possible",
            impact: "Improves safety score by 12 points"
        ),
        
        RiskTip(
            category: "Health",
            title: "Annual Checkups",
            description: "Regular wellness visits help catch issues early and reduce costs",
            impact: "Saves average $340/year"
        )
    ]
}

struct RiskTip {
    let category: String
    let title: String
    let description: String
    let impact: String
}

// Extensions for sample data
extension AppState {
    func loadSampleData() {
        self.userPolicies = MockDataService.samplePolicies
        
        // Initialize telematics with sample trips
        self.telematicsData.recentTrips = MockDataService.sampleTrips
        
        // Set realistic telematics values
        self.telematicsData.safetyScore = Int.random(in: 75...95)
        self.telematicsData.totalTrips = Int.random(in: 200...300)
        self.telematicsData.totalMiles = Double.random(in: 3000...5000)
        self.telematicsData.hardBrakes = Int.random(in: 1...8)
        self.telematicsData.rapidAccelerations = Int.random(in: 2...12)
        self.telematicsData.nightDriving = Double.random(in: 0.05...0.25)
        self.telematicsData.potentialDiscount = Double.random(in: 0.15...0.40)
    }
}

// Utility functions
class InsuranceQuoteEngine {
    static func generateQuote(for type: InsuranceType, userInfo: [String: Any] = [:]) -> Quote {
        let baseRates: [InsuranceType: Double] = [
            .house: 180.0,
            .contents: 45.0,
            .vehicle: 125.0,
            .pet: 48.0,
            .life: 85.0,
            .travel: 25.0
        ]
        
        let baseRate = baseRates[type] ?? 100.0
        let variation = Double.random(in: 0.8...1.3)
        let finalRate = baseRate * variation
        
        return Quote(
            type: type,
            monthlyPremium: finalRate,
            coverageAmount: getCoverageAmount(for: type),
            deductible: getDeductible(for: type),
            discounts: getAvailableDiscounts(for: type)
        )
    }
    
    private static func getCoverageAmount(for type: InsuranceType) -> Double {
        switch type {
        case .house: return Double.random(in: 300000...800000)
        case .contents: return Double.random(in: 25000...100000)
        case .vehicle: return Double.random(in: 25000...75000)
        case .pet: return Double.random(in: 3000...10000)
        case .life: return Double.random(in: 250000...1000000)
        case .travel: return Double.random(in: 10000...100000)
        }
    }
    
    private static func getDeductible(for type: InsuranceType) -> Double {
        switch type {
        case .house: return [500, 1000, 2500].randomElement()!
        case .contents: return [250, 500, 1000].randomElement()!
        case .vehicle: return [250, 500, 1000].randomElement()!
        case .pet: return [100, 250, 500].randomElement()!
        case .life: return 0
        case .travel: return [100, 250].randomElement()!
        }
    }
    
    private static func getAvailableDiscounts(for type: InsuranceType) -> [String] {
        switch type {
        case .house: return ["Smart Home", "Security System", "Non-Smoker", "Claims-Free"]
        case .vehicle: return ["Safe Driver", "Multi-Policy", "Anti-Theft", "Low Mileage"]
        case .pet: return ["Microchip", "Multi-Pet", "Annual Payment"]
        default: return ["Multi-Policy", "Claims-Free", "Loyalty"]
        }
    }
}

struct Quote {
    let type: InsuranceType
    let monthlyPremium: Double
    let coverageAmount: Double
    let deductible: Double
    let discounts: [String]
}