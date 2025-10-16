# Demo Insurance - Atomic SDK Setup Status

## ✅ Configuration Complete

Demo Insurance has been fully configured and is ready for Atomic SDK integration!

### What's Been Configured:

#### 1. Environment & API Key ✅
- **Environment ID:** `BJelgDpV`
- **API Key Name:** `demo-insurance-app-jwt` (✅ Created in Workbench)
- **Organization:** `512-1`
- **API Base URL:** `https://512-1.client-api.atomic.io`

#### 2. Container IDs ✅
All 8 containers are configured:

| Container | ID | Type | Purpose |
|-----------|----|----|---------|
| Overlay | `5GdbeglB` | Modal Container | Modal overlay |
| Message Center | `Wm2PoYzK` | StreamContainer | Notifications |
| Toast | `Zzeb10GQ` | SingleCardContainer | Temporary alerts |
| Horizontal Scroll | `KzRRBDzJ` | HorizontalContainer | Featured content |
| Embedded-3 | `1zyjOLGx` | SingleCardContainer | Additional content |
| Embedded-2 | `Rm0QZklj` | SingleCardContainer | Secondary content |
| Embedded | `5zg5kRmX` | SingleCardContainer | Main dashboard |
| Default | `nloaReG0` | DefaultContainer | Default container |

#### 3. JWT Authentication ✅
- ✅ RSA private key copied to `/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/atomic_demo_private_key.pem`
- ✅ Complete JWT generator with real RSA-SHA256 signing
- ✅ Session delegate configured
- ✅ User ID generation (format: `insurance-user-XXXXXXXX`)
- ✅ Persistent user IDs stored in UserDefaults

#### 4. App Initialization ✅
- ✅ `DemoInsuranceApp.swift` updated with `AACSession.login()` method
- ✅ Debug mode enabled (level 2) for detailed logging
- ✅ Matches working Demo Power pattern exactly

#### 5. SwiftUI Container Wrappers ✅
- ✅ `DemoInsuranceAtomicSingleCardContainer` - For embedded cards
- ✅ `DemoInsuranceAtomicStreamContainer` - For message feeds
- ✅ `DemoInsuranceAtomicHorizontalScrollContainer` - For horizontal scrolling
- ✅ Pre-configured with brand colors (Insurance Pink & Blue)

---

## 🔄 Next Steps (To Complete Integration)

### Step 1: Add Atomic SDK to Xcode Project

The SDK package dependency needs to be added manually in Xcode:

1. Open **DemoInsurance.xcodeproj** in Xcode
2. Select the project in the navigator
3. Select the **DemoInsurance** target
4. Go to **General** tab
5. Scroll to **Frameworks, Libraries, and Embedded Content**
6. Click **+** button
7. Select **Add Package Dependency**
8. Enter URL: `https://github.com/atomic-app/action-cards-swiftui-sdk-releases`
9. **IMPORTANT:** Select version **25.2.0** (validated stable version)
10. Add both products:
    - `AtomicSDK`
    - `AtomicSwiftUISDK`

### Step 2: Add Private Key to Xcode Target

The RSA key needs to be included in the app bundle:

1. In Xcode, right-click on `Configuration` folder
2. Select **Add Files to "DemoInsurance"...**
3. Navigate to: `/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/atomic_demo_private_key.pem`
4. **Important:** Check "Copy items if needed"
5. **Important:** Ensure target "DemoInsurance" is checked
6. Click **Add**
7. Verify in **Build Phases → Copy Bundle Resources** that the `.pem` file appears

### Step 3: Build and Test

1. Clean build folder: **Cmd+Shift+K**
2. Build: **Cmd+B**
3. Run on simulator: **Cmd+R**

4. **Check Console for Success:**
```
🚀 Demo Insurance: Initializing Atomic SDK...
🐛 Demo Insurance: Debug mode enabled (level 2)
✅ Demo Insurance: Atomic SDK initialized successfully with login()
🔐 Demo Insurance: AUTHENTICATION REQUEST RECEIVED
✅ Demo Insurance: JWT generated with REAL RSA signature
👤 User ID: insurance-user-XXXXXXXX
AtomicSDK iOS [Msg Centre] Successful authentication event received by WebSockets. {"messageType":"auth-success"}
```

5. **Verify in Workbench:**
   - Navigate to **Users** in environment `BJelgDpV`
   - Confirm user `insurance-user-XXXXXXXX` appears
   - User should show as "Active"

### Step 4: Create Test Cards

1. In Workbench, navigate to: **Cards → Create Card**
2. Select a container (e.g., Message Center: `Wm2PoYzK`)
3. Design card content
4. Publish card
5. **Card should appear in app immediately** (no rebuild required)

---

## 📋 Quick Reference

### File Locations
- **Configuration:** `/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/AtomicConfiguration.swift`
- **Session Delegate:** `/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/DemoInsuranceAtomicSessionDelegate.swift`
- **App Entry Point:** `/Users/bradleysimpson/Demo Insurance/DemoInsurance/DemoInsuranceApp.swift`
- **Private Key:** `/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/atomic_demo_private_key.pem`
- **Public Key:** (Same as Demo Power) `/Users/bradleysimpson/Demo Power/Demo Power/atomic_demo_public_key.pem`

### Container IDs Quick Reference
```swift
DemoInsuranceAtomicConfiguration.overlayContainerID              // 5GdbeglB
DemoInsuranceAtomicConfiguration.messageCenterContainerID        // Wm2PoYzK
DemoInsuranceAtomicConfiguration.toastContainerID                // Zzeb10GQ
DemoInsuranceAtomicConfiguration.horizontalScrollContainerID     // KzRRBDzJ
DemoInsuranceAtomicConfiguration.embedded3ContainerID            // 1zyjOLGx
DemoInsuranceAtomicConfiguration.embedded2ContainerID            // Rm0QZklj
DemoInsuranceAtomicConfiguration.embeddedContainerID             // 5zg5kRmX
DemoInsuranceAtomicConfiguration.defaultContainerID              // nloaReG0
```

### API Credentials
- **Environment ID:** `BJelgDpV`
- **API Key:** `demo-insurance-app-jwt` (✅ Created in Workbench)
- **Organization:** `512-1`

---

## 🔍 Troubleshooting

### Build Error: "No such module 'AtomicSDK'"
**Solution:** SDK not added to project. Follow Step 1 above.

### Build Error: "Could not find atomic_demo_private_key.pem"
**Solution:** Private key not in bundle. Follow Step 2 above.

### Runtime: "Invalid token sent"
**Solutions:**
1. Verify API key exists in Workbench and is Active
2. Verify API key is associated with environment `BJelgDpV`
3. Verify public key in Workbench matches the private key in app
4. If JWT validates in Workbench tester but runtime fails: **Delete and recreate API key** (this clears backend cache issues)

### User Not Appearing in Workbench
**Check:**
- Authentication successful in console (look for "auth-success")
- WebSocket connected
- Environment ID matches (`BJelgDpV`)
- API key associated with correct environment

---

## ✨ Ready to Go!

Once you complete Steps 1-2 above, Demo Insurance will have full Atomic SDK integration with:
- ✅ JWT authentication with RSA signing
- ✅ 8 containers ready for content
- ✅ User registration and tracking
- ✅ Real-time card updates
- ✅ Insurance-specific action handlers (claims, quotes, policies, etc.)

The configuration matches the validated Demo Power pattern that's currently working successfully.

---

## 🎯 Insurance-Specific Features

The session delegate includes handlers for:
- 📋 **File Claim** - Navigate to claims flow
- 📄 **View Policy** - Display policy details
- 💰 **Request Quote** - Start quote process
- 🏆 **Safety Score** - Show driving score
- 💳 **Payment Reminder** - Navigate to payment
- 🚗 **Roadside Assistance** - Emergency services

---

**Generated:** October 14, 2025
**Configuration Version:** 1.0
**Based on:** Demo Power working implementation
**API Key Status:** ✅ Created in Workbench
