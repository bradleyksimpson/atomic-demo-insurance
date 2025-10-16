import SwiftUI

struct SmartHomeView: View {
    @State private var devices = [
        SmartDevice(name: "Water Sensor", type: .waterSensor, status: .active, room: "Basement"),
        SmartDevice(name: "Smoke Detector", type: .smokeDetector, status: .active, room: "Kitchen"),
        SmartDevice(name: "Security Camera", type: .camera, status: .active, room: "Front Door"),
        SmartDevice(name: "Smart Lock", type: .lock, status: .active, room: "Main Entry"),
        SmartDevice(name: "Motion Sensor", type: .motionSensor, status: .active, room: "Living Room")
    ]
    
    @State private var showAddDevice = false
    @State private var riskScore = 15 // Out of 100, lower is better
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Risk score card
                    riskScoreCard
                    
                    // Device status overview
                    deviceOverview
                    
                    // Active alerts
                    alertsSection
                    
                    // Connected devices
                    devicesSection
                    
                    // Risk reduction tips
                    tipsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .background(Theme.backgroundGray)
            .navigationTitle("Smart Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddDevice = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.primaryPink)
                    }
                }
            }
            .sheet(isPresented: $showAddDevice) {
                AddDeviceView()
            }
        }
    }
    
    var riskScoreCard: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Home Risk Score")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack(alignment: .bottom) {
                        Text("\(riskScore)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        Text("/ 100")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Text("Excellent protection")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Risk gauge
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 12)
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .trim(from: 0, to: 1 - Double(riskScore) / 100)
                        .stroke(.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            
            // Discount earned
            HStack {
                Text("Your smart home devices earned you a")
                    .foregroundColor(.white.opacity(0.9))
                
                Text("15% discount")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color.green, Color.teal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
    
    var deviceOverview: some View {
        HStack(spacing: 16) {
            DeviceStatusCard(
                count: devices.filter { $0.status == .active }.count,
                total: devices.count,
                title: "Active Devices",
                icon: "checkmark.shield.fill",
                color: Theme.success
            )
            
            DeviceStatusCard(
                count: 0,
                total: nil,
                title: "Alerts",
                icon: "exclamationmark.triangle.fill",
                color: Theme.warning
            )
            
            DeviceStatusCard(
                count: 1,
                total: nil,
                title: "Offline",
                icon: "wifi.slash",
                color: Color.gray
            )
        }
    }
    
    var alertsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Alerts")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Button("View All") {
                    // Action
                }
                .foregroundColor(Theme.primaryPink)
            }
            
            // Sample alerts
            VStack(spacing: 12) {
                AlertCard(
                    icon: "drop.fill",
                    title: "Water sensor detected moisture",
                    subtitle: "Basement • 2 hours ago",
                    severity: .low,
                    isResolved: true
                )
                
                AlertCard(
                    icon: "lock.open.fill",
                    title: "Front door unlocked",
                    subtitle: "Main Entry • 5 hours ago",
                    severity: .medium,
                    isResolved: false
                )
            }
        }
    }
    
    var devicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Connected Devices")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(devices) { device in
                    SmartDeviceCard(device: device)
                }
            }
        }
    }
    
    var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Reduction Tips")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 12) {
                RiskTipCard(
                    icon: "thermometer.variable.and.figure",
                    title: "Install Smart Thermostat",
                    description: "Prevent frozen pipes and save on energy costs",
                    potentialSavings: 8,
                    color: Color.blue
                )
                
                RiskTipCard(
                    icon: "video.fill",
                    title: "Add Security Cameras",
                    description: "Deter theft and monitor your property remotely",
                    potentialSavings: 12,
                    color: Color.purple
                )
            }
        }
    }
}

struct SmartDevice: Identifiable {
    let id = UUID()
    let name: String
    let type: DeviceType
    let status: DeviceStatus
    let room: String
    
    enum DeviceType {
        case waterSensor, smokeDetector, camera, lock, motionSensor, thermostat
        
        var icon: String {
            switch self {
            case .waterSensor: return "drop.fill"
            case .smokeDetector: return "smoke.fill"
            case .camera: return "video.fill"
            case .lock: return "lock.fill"
            case .motionSensor: return "sensor.fill"
            case .thermostat: return "thermometer"
            }
        }
        
        var color: Color {
            switch self {
            case .waterSensor: return .blue
            case .smokeDetector: return .red
            case .camera: return .purple
            case .lock: return .orange
            case .motionSensor: return .green
            case .thermostat: return .teal
            }
        }
    }
    
    enum DeviceStatus {
        case active, offline, alerting
        
        var color: Color {
            switch self {
            case .active: return Theme.success
            case .offline: return Color.gray
            case .alerting: return Theme.danger
            }
        }
        
        var text: String {
            switch self {
            case .active: return "Active"
            case .offline: return "Offline"
            case .alerting: return "Alert"
            }
        }
    }
}

struct SmartDeviceCard: View {
    let device: SmartDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(device.type.color.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: device.type.icon)
                            .font(.system(size: 20))
                            .foregroundColor(device.type.color)
                    )
                
                Spacer()
                
                Circle()
                    .fill(device.status.color)
                    .frame(width: 10, height: 10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(device.room)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                
                Text(device.status.text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(device.status.color)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
    }
}

struct DeviceStatusCard: View {
    let count: Int
    let total: Int?
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            if let total = total {
                Text("\(count)/\(total)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            } else {
                Text("\(count)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
    }
}

struct AlertCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let severity: AlertSeverity
    let isResolved: Bool
    
    enum AlertSeverity {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return Theme.info
            case .medium: return Theme.warning
            case .high: return Theme.danger
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(severity.color.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(severity.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            if isResolved {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.success)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
        .opacity(isResolved ? 0.7 : 1.0)
    }
}

struct RiskTipCard: View {
    let icon: String
    let title: String
    let description: String
    let potentialSavings: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text("Save \(potentialSavings)%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.success.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
    }
}

struct AddDeviceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDeviceType: SmartDevice.DeviceType?
    
    let availableDevices: [SmartDevice.DeviceType] = [
        .waterSensor, .smokeDetector, .camera, .lock, .motionSensor, .thermostat
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Add Smart Device")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Connect devices to monitor your home and earn additional discounts")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(availableDevices, id: \.self) { deviceType in
                        DeviceTypeCard(
                            deviceType: deviceType,
                            isSelected: selectedDeviceType == deviceType
                        ) {
                            selectedDeviceType = deviceType
                        }
                    }
                }
                
                if selectedDeviceType != nil {
                    VStack(spacing: 16) {
                        Text("Benefits of adding this device:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BenefitRow(text: "Real-time monitoring and alerts")
                            BenefitRow(text: "Prevent costly damage")
                            BenefitRow(text: "Additional premium discount")
                        }
                    }
                    .padding()
                    .background(Theme.lightPink)
                    .cornerRadius(12)
                }
                
                Spacer()
                
                Button("Connect Device") {
                    // Connection flow
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(selectedDeviceType == nil)
                .opacity(selectedDeviceType == nil ? 0.6 : 1.0)
            }
            .padding()
            .navigationTitle("Add Device")
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
}

struct DeviceTypeCard: View {
    let deviceType: SmartDevice.DeviceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Circle()
                    .fill(isSelected ? deviceType.color.opacity(0.2) : deviceType.color.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: deviceType.icon)
                            .font(.system(size: 28))
                            .foregroundColor(deviceType.color)
                    )
                
                Text(deviceTypeName(deviceType))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? deviceType.color : Color.clear, lineWidth: 2)
            )
            .shadow(color: Theme.cardShadow, radius: 2, x: 0, y: 1)
        }
    }
    
    func deviceTypeName(_ type: SmartDevice.DeviceType) -> String {
        switch type {
        case .waterSensor: return "Water Sensor"
        case .smokeDetector: return "Smoke Detector"
        case .camera: return "Security Camera"
        case .lock: return "Smart Lock"
        case .motionSensor: return "Motion Sensor"
        case .thermostat: return "Thermostat"
        }
    }
}

struct BenefitRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(Theme.success)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

#Preview {
    SmartHomeView()
}