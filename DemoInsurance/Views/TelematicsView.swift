import SwiftUI
import Charts

struct TelematicsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTimeRange = 0
    let timeRanges = ["Week", "Month", "Year"]
    
    // Sample data for charts
    let weeklyScores = [
        (day: "Mon", score: 82),
        (day: "Tue", score: 88),
        (day: "Wed", score: 85),
        (day: "Thu", score: 91),
        (day: "Fri", score: 87),
        (day: "Sat", score: 93),
        (day: "Sun", score: 90)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with score
                    drivingScoreCard
                    
                    // Potential savings
                    savingsCard

                    // Atomic Horizontal Scroll Container - Driving Tips & Insights
                    #if canImport(AtomicSwiftUISDK)
                    DemoInsuranceAtomicHorizontalScrollContainer(containerID: DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)
                        .frame(maxWidth: .infinity)
                    #else
                    InsuranceAtomicHorizontalPlaceholder(containerID: DemoInsuranceAtomicConfiguration.horizontalScrollContainerID)
                        .frame(maxWidth: .infinity)
                    #endif

                    // Enhanced Time range selector with better contrast
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Time Period")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                            .padding(.horizontal)
                        
                        Picker("Time Range", selection: $selectedTimeRange) {
                            ForEach(0..<timeRanges.count, id: \.self) { index in
                                Text(timeRanges[index])
                                    .font(.system(size: 16, weight: .medium))
                                    .tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Theme.cardShadow, radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    // Driving insights
                    drivingInsightsSection
                    
                    // Score trend chart
                    scoreTrendChart
                    
                    // Recent trips
                    recentTripsSection
                    
                    // Tips section
                    drivingTipsSection
                }
                .padding(.bottom, 100)
            }
            .background(Theme.backgroundGray)
            .navigationTitle("Drive & Save")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    var drivingScoreCard: some View {
        VStack(spacing: 20) {
            // Score circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(appState.telematicsData.safetyScore) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [Theme.success, Theme.primaryPink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: appState.telematicsData.safetyScore)
                
                VStack(spacing: 8) {
                    Text("\(appState.telematicsData.safetyScore)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Driving Score")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Stats row
            HStack(spacing: 30) {
                VStack(spacing: 4) {
                    Text("\(appState.telematicsData.totalTrips)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text("Trips")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(Int(appState.telematicsData.totalMiles))")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text("Miles")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(Int(appState.telematicsData.potentialDiscount * 100))%")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Theme.success)
                    Text("Discount")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    var savingsCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your potential annual savings")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("$\(Int(appState.telematicsData.potentialDiscount * 800))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .background(Theme.primaryGradient)
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    var drivingInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Driving Insights")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                EnhancedInsightRow(
                    icon: "speedometer",
                    title: "Speed Control",
                    value: "Excellent",
                    description: "Maintaining safe speeds",
                    color: Theme.success
                )
                
                EnhancedInsightRow(
                    icon: "location.fill",
                    title: "Hard Braking",
                    value: "\(appState.telematicsData.hardBrakes) events",
                    description: "Last week",
                    color: Theme.warning
                )
                
                EnhancedInsightRow(
                    icon: "bolt.fill",
                    title: "Acceleration",
                    value: "\(appState.telematicsData.rapidAccelerations) events",
                    description: "Rapid starts detected",
                    color: Theme.warning
                )
                
                EnhancedInsightRow(
                    icon: "moon.fill",
                    title: "Night Driving",
                    value: "\(Int(appState.telematicsData.nightDriving * 100))%",
                    description: "Of total driving time",
                    color: Theme.info
                )
            }
            .padding(.horizontal)
        }
    }
    
    var scoreTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly Score Trend")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Your driving performance over time")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                // Current week average
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Avg")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                    Text("88")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.success)
                }
            }
            .padding(.horizontal)
            
            // Enhanced chart with better contrast
            Chart(weeklyScores, id: \.day) { item in
                LineMark(
                    x: .value("Day", item.day),
                    y: .value("Score", item.score)
                )
                .foregroundStyle(Theme.primaryPink)
                .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round))
                
                AreaMark(
                    x: .value("Day", item.day),
                    y: .value("Score", item.score)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.primaryPink.opacity(0.3), Theme.primaryPink.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Add point markers for better visibility
                PointMark(
                    x: .value("Day", item.day),
                    y: .value("Score", item.score)
                )
                .foregroundStyle(Theme.primaryPink)
                .symbolSize(60)
            }
            .chartYScale(domain: 70...100)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                        .foregroundStyle(Color.gray.opacity(0.2))
                    AxisValueLabel()
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.gray.opacity(0.2))
                    AxisValueLabel()
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                }
            }
            .frame(height: 220)
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
    
    var recentTripsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Trips")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                TripRow(
                    date: Date(),
                    distance: 15.3,
                    score: 92,
                    route: "Home → Office"
                )
                
                TripRow(
                    date: Date().addingTimeInterval(-86400),
                    distance: 28.7,
                    score: 88,
                    route: "Office → Grocery → Home"
                )
                
                TripRow(
                    date: Date().addingTimeInterval(-172800),
                    distance: 42.1,
                    score: 85,
                    route: "Weekend Trip"
                )
            }
            .padding(.horizontal)
        }
    }
    
    var drivingTipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tips to Improve")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                TipCard(
                    icon: "lightbulb.fill",
                    title: "Smooth Acceleration",
                    description: "Avoid rapid starts to improve fuel efficiency and safety score",
                    color: .yellow
                )
                
                TipCard(
                    icon: "clock.fill",
                    title: "Plan Your Trips",
                    description: "Combine errands to reduce overall mileage and save on fuel",
                    color: .blue
                )
            }
            .padding(.horizontal)
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                )
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// Enhanced version with better readability
struct EnhancedInsightRow: View {
    let icon: String
    let title: String
    let value: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Enhanced icon with better contrast
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
            }
            
            // Content with improved typography
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text(value)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Theme.cardShadow, radius: 6, x: 0, y: 3)
    }
}

struct TripRow: View {
    let date: Date
    let distance: Double
    let score: Int
    let route: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(route)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text("\(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(scoreColor(score))
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(scoreColor(score))
                }
                
                Text("\(String(format: "%.1f", distance)) mi")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    func scoreColor(_ score: Int) -> Color {
        if score >= 90 { return Theme.success }
        if score >= 70 { return Theme.warning }
        return Theme.danger
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    TelematicsView()
        .environmentObject(AppState())
}