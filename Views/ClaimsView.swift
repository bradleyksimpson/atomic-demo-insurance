import SwiftUI
import PhotosUI

struct ClaimsView: View {
    @State private var showNewClaim = false
    @State private var activeClaims: [Claim] = [
        Claim(
            policyId: UUID(),
            claimNumber: "CLM-2024-0142",
            date: Date().addingTimeInterval(-86400 * 3),
            type: "Auto Collision",
            description: "Minor fender bender in parking lot",
            amount: 2500,
            status: .underReview,
            photos: ["photo1", "photo2"]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick claim button
                    quickClaimSection
                    
                    // Claims summary
                    claimsSummaryCards
                    
                    // Active claims
                    if !activeClaims.isEmpty {
                        activeClaimsSection
                    }
                    
                    // Atomic Stream Container - Insurance Notifications
                    VStack(spacing: 0) {
                        HStack {
                            Text("Insurance Notifications")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            Spacer()
                            
                            Text("Container: \(DemoInsuranceAtomicConfiguration.messageCenterContainerID)")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                        
                        // Real Atomic Stream Container with glass background
                        ZStack {
                            // Glass background maintaining design consistency
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.4))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: Theme.cardShadow, radius: 15, x: 0, y: 8)
                            
                            #if canImport(AtomicSwiftUISDK)
                            DemoInsuranceAtomicStreamContainer(containerID: DemoInsuranceAtomicConfiguration.messageCenterContainerID)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(4)
                            #else
                            InsuranceAtomicStreamPlaceholder(containerID: DemoInsuranceAtomicConfiguration.messageCenterContainerID)
                            #endif
                        }
                        .frame(height: 260)
                        .padding(.horizontal, 20)
                    }
                    
                    // Claims history
                    claimsHistorySection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .background(Theme.backgroundGray)
            .navigationTitle("Claims")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showNewClaim) {
                NewClaimView()
            }
        }
    }
    
    var quickClaimSection: some View {
        VStack(spacing: 16) {
            // Hero card
            VStack(spacing: 20) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Text("File a claim in minutes")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Just snap a photo and we'll handle the rest")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                
                Button(action: { showNewClaim = true }) {
                    Text("Start New Claim")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Theme.primaryPink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
            .padding(30)
            .frame(maxWidth: .infinity)
            .background(Theme.primaryGradient)
            .cornerRadius(20)
        }
    }
    
    var claimsSummaryCards: some View {
        HStack(spacing: 16) {
            SummaryCard(
                title: "Active Claims",
                value: "\(activeClaims.filter { $0.status != .paid && $0.status != .rejected }.count)",
                icon: "doc.text.fill",
                color: Theme.warning
            )
            
            SummaryCard(
                title: "Total Paid",
                value: "$12,450",
                icon: "dollarsign.circle.fill",
                color: Theme.success
            )
        }
    }
    
    var activeClaimsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Claims")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(activeClaims) { claim in
                ClaimCard(claim: claim)
            }
        }
    }
    
    var claimsHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Claims History")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    // Action
                }
                .foregroundColor(Theme.primaryPink)
            }
            
            // Sample history items
            VStack(spacing: 12) {
                HistoryItem(
                    date: Date().addingTimeInterval(-86400 * 30),
                    type: "Home - Water damage",
                    amount: 4500,
                    status: .paid
                )
                
                HistoryItem(
                    date: Date().addingTimeInterval(-86400 * 90),
                    type: "Auto - Windshield replacement",
                    amount: 450,
                    status: .paid
                )
            }
        }
    }
}

struct NewClaimView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var claimType = ""
    @State private var description = ""
    @State private var showCamera = false
    @State private var currentStep = 1
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(currentStep: currentStep, totalSteps: 4)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case 1:
                            selectTypeStep
                        case 2:
                            photoUploadStep
                        case 3:
                            descriptionStep
                        case 4:
                            reviewStep
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 1 {
                        Button("Back") {
                            currentStep -= 1
                        }
                        .foregroundColor(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Button(currentStep == 4 ? "Submit Claim" : "Continue") {
                        if currentStep < 4 {
                            currentStep += 1
                        } else {
                            // Submit claim
                            dismiss()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
            }
            .navigationTitle("New Claim")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var selectTypeStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What type of claim?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 12) {
                ClaimTypeOption(
                    icon: "car.fill",
                    title: "Auto",
                    isSelected: claimType == "Auto"
                ) {
                    claimType = "Auto"
                }
                
                ClaimTypeOption(
                    icon: "house.fill",
                    title: "Home",
                    isSelected: claimType == "Home"
                ) {
                    claimType = "Home"
                }
                
                ClaimTypeOption(
                    icon: "shippingbox.fill",
                    title: "Contents",
                    isSelected: claimType == "Contents"
                ) {
                    claimType = "Contents"
                }
            }
        }
    }
    
    var photoUploadStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Upload photos of damage")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Take or upload photos to help us assess the damage quickly")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
            
            // Photo grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(selectedImages.indices, id: \.self) { index in
                    Image(uiImage: selectedImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(12)
                }
                
                // Add photo button
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 10,
                    matching: .images
                ) {
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(Theme.primaryPink)
                        
                        Text("Add Photo")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Camera button
                Button(action: { showCamera = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Theme.primaryPink)
                        
                        Text("Take Photo")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // AI Analysis preview
            if !selectedImages.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Label("AI Damage Assessment", systemImage: "brain")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.primaryPink)
                    
                    Text("Based on the photos, we estimate:")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    HStack {
                        Text("Repair Cost:")
                            .font(.system(size: 16))
                        Spacer()
                        Text("$1,200 - $1,800")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.primaryPink)
                    }
                    .padding()
                    .background(Theme.lightPink)
                    .cornerRadius(12)
                }
                .padding(.top)
            }
        }
        .onChange(of: selectedPhotos) { items in
            Task {
                selectedImages = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
    
    var descriptionStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Tell us what happened")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("A brief description helps us process your claim faster")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
            
            TextEditor(text: $description)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .frame(minHeight: 150)
            
            // Quick options
            VStack(alignment: .leading, spacing: 12) {
                Text("Common situations:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                
                FlowLayout(spacing: 8) {
                    ForEach(["Accident", "Weather damage", "Theft", "Fire", "Water damage"], id: \.self) { option in
                        Button(option) {
                            if description.isEmpty {
                                description = option
                            } else {
                                description += ", \(option)"
                            }
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Theme.lightPink)
                        .foregroundColor(Theme.primaryPink)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    var reviewStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Review your claim")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            // Summary card
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Claim Type:")
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text(claimType)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Photos:")
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("\(selectedImages.count) uploaded")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Estimated Repair:")
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("$1,200 - $1,800")
                        .fontWeight(.medium)
                        .foregroundColor(Theme.primaryPink)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description:")
                        .foregroundColor(Theme.textSecondary)
                    Text(description)
                        .font(.system(size: 14))
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
            
            // Next steps
            VStack(alignment: .leading, spacing: 12) {
                Label("What happens next?", systemImage: "info.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.info)
                
                VStack(alignment: .leading, spacing: 8) {
                    NextStep(number: 1, text: "We'll review your claim within 24 hours")
                    NextStep(number: 2, text: "An adjuster may contact you if needed")
                    NextStep(number: 3, text: "Payment processed within 3 business days")
                }
            }
            .padding()
            .background(Theme.info.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 4)
                    .fill(step <= currentStep ? Theme.primaryPink : Color.gray.opacity(0.3))
                    .frame(height: 8)
            }
        }
    }
}

struct ClaimTypeOption: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(isSelected ? Theme.primaryPink.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(isSelected ? Theme.primaryPink : Theme.textSecondary)
                    )
                
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.primaryPink)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.primaryPink : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct ClaimCard: View {
    let claim: Claim
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(claim.claimNumber)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text(claim.type)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Spacer()
                
                StatusBadge(status: claim.status)
            }
            
            Text(claim.description)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(2)
            
            HStack {
                Label("\(claim.date.formatted(date: .abbreviated, time: .omitted))", 
                      systemImage: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Text("$\(Int(claim.amount))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            // Photo preview
            if !claim.photos.isEmpty {
                HStack(spacing: 8) {
                    ForEach(0..<min(3, claim.photos.count), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(Color.gray)
                            )
                    }
                    
                    if claim.photos.count > 3 {
                        Text("+\(claim.photos.count - 3)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct HistoryItem: View {
    let date: Date
    let type: String
    let amount: Double
    let status: Claim.ClaimStatus
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(type)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(Int(amount))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                StatusBadge(status: status, small: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct StatusBadge: View {
    let status: Claim.ClaimStatus
    var small: Bool = false
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: small ? 12 : 14, weight: .medium))
            .foregroundColor(status.color)
            .padding(.horizontal, small ? 8 : 12)
            .padding(.vertical, small ? 4 : 6)
            .background(status.color.opacity(0.1))
            .cornerRadius(small ? 6 : 8)
    }
}

struct NextStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Theme.info)
                .frame(width: 24, height: 24)
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                )
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

// Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: frame.origin.x + bounds.minX,
                                             y: frame.origin.y + bounds.minY),
                                 proposal: ProposedViewSize(frame.size))
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let viewSize = subview.sizeThatFits(.unspecified)
                
                if currentX + viewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY),
                                   size: viewSize))
                
                currentX += viewSize.width + spacing
                lineHeight = max(lineHeight, viewSize.height)
                
                size.width = max(size.width, currentX - spacing)
                size.height = currentY + lineHeight
            }
        }
    }
}

// MARK: - Atomic Stream Placeholder for Demo Insurance
struct InsuranceAtomicStreamPlaceholder: View {
    let containerID: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Insurance Notifications")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Text("Container: \(containerID)")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.horizontal, 20)
            
            // Stream of notification cards
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<4) { index in
                        InsuranceNotificationCard(
                            title: [
                                "Policy Renewal Due",
                                "New Discount Available", 
                                "Claim Update",
                                "Safety Score Improved"
                            ][index],
                            message: [
                                "Your auto insurance policy renews in 30 days",
                                "You qualify for a 15% safe driver discount",
                                "Your claim CLM-2024-0142 is being processed",
                                "Your driving score improved to 85/100 - save more!"
                            ][index],
                            icon: ["📋", "💰", "📄", "🏆"][index],
                            color: [Theme.primaryPink, .green, .blue, .orange][index]
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct InsuranceNotificationCard: View {
    let title: String
    let message: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                Text(icon)
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                
                Text(message)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Time indicator
            VStack {
                Text("SDK")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
                
                Text("Ready")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(.green.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ClaimsView()
}