import SwiftUI

struct Theme {
    // MARK: - Primary Brand Colors (Lemonade-inspired)
    static let primaryPink = Color(red: 255/255, green: 0/255, blue: 131/255) // #FF0083
    static let darkPink = Color(red: 204/255, green: 0/255, blue: 105/255)    // #CC0069
    static let lightPink = Color(red: 255/255, green: 240/255, blue: 245/255) // #FFF0F5

    // MARK: - Neutral Colors
    static let backgroundGray = Color(red: 248/255, green: 248/255, blue: 250/255) // #F8F8FA
    static let textPrimary = Color(red: 33/255, green: 33/255, blue: 33/255)       // #212121
    static let textSecondary = Color(red: 117/255, green: 117/255, blue: 117/255)  // #757575
    static let textTertiary = Color(red: 156/255, green: 163/255, blue: 175/255)   // #9CA3AF

    // MARK: - Semantic Colors
    static let success = Color(red: 52/255, green: 199/255, blue: 89/255)   // #34C759
    static let warning = Color(red: 255/255, green: 149/255, blue: 0/255)   // #FF9500
    static let danger = Color(red: 255/255, green: 59/255, blue: 48/255)    // #FF3B30
    static let info = Color(red: 0/255, green: 122/255, blue: 255/255)      // #007AFF

    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primaryPink, darkPink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        gradient: Gradient(colors: [success, success.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Shadows
    static let cardShadow = Color.black.opacity(0.05)
    static let elevatedShadow = Color.black.opacity(0.08)
    static let subtleShadow = Color.black.opacity(0.03)
}

// MARK: - Spacing System (Following Demo Power Pattern)
/// Consistent spacing values for layout throughout the app
enum InsuranceSpacing: CGFloat {
    case xxs = 4
    case xs = 8
    case sm = 12
    case md = 16      // Standard card padding, inline spacing
    case lg = 20      // Section separation
    case xl = 24      // Page horizontal margins
    case xxl = 32
    case xxxl = 48

    // Tab bar safe area padding
    static let tabBarSafeArea: CGFloat = 100
}

// MARK: - Corner Radius System
enum InsuranceRadius: CGFloat {
    case xs = 4       // Small badges
    case sm = 8       // Buttons, chips
    case md = 12      // Standard cards
    case lg = 16      // Large cards, containers
    case xl = 20      // Hero cards
    case xxl = 24     // Bottom sheets, modals
}

// MARK: - Icon Sizes
enum InsuranceIconSize: CGFloat {
    case small = 16       // Inline badges
    case medium = 20      // Standard inline icons
    case large = 24       // Card header icons
    case xlarge = 32      // Feature icons
    case hero = 48        // Hero/header icons
}

// MARK: - View Extension for Spacing
extension View {
    /// Standard page horizontal padding (24pt)
    func insurancePagePadding() -> some View {
        self.padding(.horizontal, InsuranceSpacing.xl.rawValue)
    }

    /// Standard card internal padding (16pt)
    func insuranceCardPadding() -> some View {
        self.padding(InsuranceSpacing.md.rawValue)
    }

    /// Standard section spacing (20pt vertical)
    func insuranceSectionSpacing() -> some View {
        self.padding(.vertical, InsuranceSpacing.lg.rawValue)
    }

    /// Standard card shadow
    func insuranceCardShadow() -> some View {
        self.shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 4)
    }

    /// Elevated shadow for prominent elements
    func insuranceElevatedShadow() -> some View {
        self.shadow(color: Theme.elevatedShadow, radius: 16, x: 0, y: 8)
    }

    /// Apply consistent padding for Atomic containers to align with surrounding content
    func insuranceContainerAlignment() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.horizontal, InsuranceSpacing.md.rawValue)
    }
}

// Custom modifiers for consistent styling
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryGradient)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}