import SwiftUI

struct Theme {
    // Lemonade-inspired colors
    static let primaryPink = Color(red: 255/255, green: 0/255, blue: 131/255) // #FF0083
    static let darkPink = Color(red: 204/255, green: 0/255, blue: 105/255)
    static let lightPink = Color(red: 255/255, green: 240/255, blue: 245/255)
    
    // Neutral colors
    static let backgroundGray = Color(red: 248/255, green: 248/255, blue: 250/255)
    static let textPrimary = Color(red: 33/255, green: 33/255, blue: 33/255)
    static let textSecondary = Color(red: 117/255, green: 117/255, blue: 117/255)
    
    // Semantic colors
    static let success = Color(red: 52/255, green: 199/255, blue: 89/255)
    static let warning = Color(red: 255/255, green: 149/255, blue: 0/255)
    static let danger = Color(red: 255/255, green: 59/255, blue: 48/255)
    static let info = Color(red: 0/255, green: 122/255, blue: 255/255)
    
    // Gradients
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primaryPink, darkPink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Shadows
    static let cardShadow = Color.black.opacity(0.05)
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