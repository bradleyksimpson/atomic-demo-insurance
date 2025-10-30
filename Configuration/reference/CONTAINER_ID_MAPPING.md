# Demo Insurance - Container ID Mapping

**Source:** Sales_Demos - 512-1 BJelgDpV Insurance.csv
**Date:** October 30, 2025
**Organization ID:** 512-1
**Environment ID:** BJelgDpV

---

## Container ID Reference

All container IDs from the CSV have been correctly implemented in the Demo Insurance app.

| CSV Name | Container ID | Stream | Type | Tab Location | Code Variable | Status |
|----------|--------------|--------|------|--------------|---------------|--------|
| **Overlay** | `5GdbeglB` | Overlay | Modal Container | Schedule | `overlayContainerID` | ✅ Implemented |
| **Toast** | `Zzeb10GQ` | Toast | SingleCardContainer | Schedule | `toastContainerID` | ✅ Implemented |
| **Embedded** | `5zg5kRmX` | Embedded | SingleCardContainer | Schedule | `embeddedContainerID` | ✅ Implemented |
| **Embedded-2** | `Rm0QZklj` | Embedded-2 | SingleCardContainer | Map | `embedded2ContainerID` | ✅ Implemented |
| **Embedded-3** | `1zyjOLGx` | Embedded-3 | SingleCardContainer | Network | `embedded3ContainerID` | ✅ Implemented |
| **Horizontal_Scroll** | `KzRRBDzJ` | Horizontal_Scroll | HorizontalContainer | More | `horizontalScrollContainerID` | ✅ Implemented |
| **Message_Center** | `Wm2PoYzK` | Message_Center | StreamContainer | Messages | `messageCenterContainerID` | ✅ Implemented |

---

## Container Details from CSV

### 1. Overlay Container
- **ID:** 5GdbeglB
- **Type:** Modal Container
- **Card Limit:** 50
- **Tab:** Schedule
- **Location:** Overlay exactly like the overlay in the Demo Education app
- **Implementation:** Modal overlay for important notifications
- **Code Location:** `AtomicConfiguration.swift:31`

### 2. Toast Container
- **ID:** Zzeb10GQ
- **Type:** SingleCardContainer
- **Card Limit:** 1
- **Tab:** Schedule
- **Location:** Toast exactly like in the Demo Education app
- **Implementation:** Bottom sheet for temporary alerts
- **Code Location:** `AtomicConfiguration.swift:33`

### 3. Embedded Container
- **ID:** 5zg5kRmX
- **Type:** SingleCardContainer
- **Card Limit:** 50
- **Tab:** Schedule
- **Location:** Immediately below the events horizontal scrolling container
- **Implementation:** Main dashboard embedded container
- **Code Location:** `AtomicConfiguration.swift:37`

### 4. Embedded-2 Container
- **ID:** Rm0QZklj
- **Type:** SingleCardContainer
- **Card Limit:** 50
- **Tab:** Map
- **Location:** At bottom of scrolling container
- **Implementation:** Secondary content in Map view
- **Code Location:** `AtomicConfiguration.swift:36`

### 5. Embedded-3 Container
- **ID:** 1zyjOLGx
- **Type:** SingleCardContainer
- **Card Limit:** 50
- **Tab:** Network
- **Location:** Above search and below QR code
- **Implementation:** Additional content in Network view
- **Code Location:** `AtomicConfiguration.swift:35`

### 6. Horizontal Scroll Container
- **ID:** KzRRBDzJ
- **Type:** HorizontalContainer
- **Card Limit:** 50
- **Tab:** More
- **Location:** Below names and role and above event information
- **Implementation:** Featured content carousel
- **Code Location:** `AtomicConfiguration.swift:34`

### 7. Message Center Container
- **ID:** Wm2PoYzK
- **Type:** StreamContainer
- **Card Limit:** 100
- **Tab:** Messages
- **Location:** Message Center exactly like the Demo Education app
- **Implementation:** Full message stream
- **Code Location:** `AtomicConfiguration.swift:32`

---

## Implementation Files

### Configuration Files
- **AtomicConfiguration.swift** - Lines 31-38
  - All 7 container IDs defined as static constants
  - Environment ID: BJelgDpV
  - Organization ID: 512-1
  - API Host: https://512-1.customer-api.atomic.io

### Container Wrappers
- **AtomicSwiftUIContainers.swift**
  - SwiftUI views for each container type
  - Insurance-specific configurations
  - Placeholder mode support

### View Implementations
Container placements across the app:
- **Schedule Tab** - Embedded, Toast, Overlay
- **Map Tab** - Embedded-2
- **Network Tab** - Embedded-3
- **More Tab** - Horizontal Scroll
- **Messages Tab** - Message Center

---

## Code Reference

### Container ID Constants (AtomicConfiguration.swift:31-38)

```swift
// Container IDs from container_id_512-1_BJelgDpV_Insurance.csv
static let overlayContainerID = "5GdbeglB"           // OverlayActive - Modal overlay
static let messageCenterContainerID = "Wm2PoYzK"    // Message_CenterActive for notifications
static let toastContainerID = "Zzeb10GQ"            // ToastActive for temporary alerts
static let horizontalScrollContainerID = "KzRRBDzJ" // Horizontal_ScrollActive for featured content
static let embedded3ContainerID = "1zyjOLGx"        // Embedded-3Active for additional content
static let embedded2ContainerID = "Rm0QZklj"        // Embedded-2Active for secondary content
static let embeddedContainerID = "5zg5kRmX"         // EmbeddedActive for main dashboard
```

---

## Verification Checklist

✅ All 7 container IDs from CSV are implemented in code
✅ Container IDs match exactly (case-sensitive)
✅ Each container has correct type (Modal, SingleCard, Horizontal, Stream)
✅ Tab locations documented in CSV match implementation intent
✅ Card limits noted for capacity planning
✅ Environment and Organization IDs configured correctly

---

## Usage Notes

### For Developers
- Always reference this document when adding new containers
- Container IDs are immutable - do not change in production
- Use the documented tab locations for consistent UX
- Respect card limits when designing card content

### For Content Creators
- **Overlay (5GdbeglB):** Use for critical notifications requiring user attention
- **Toast (Zzeb10GQ):** Use for quick, dismissible messages (max 1 card)
- **Embedded (5zg5kRmX):** Use for primary dashboard content
- **Embedded-2 (Rm0QZklj):** Use for Map-related contextual content
- **Embedded-3 (1zyjOLGx):** Use for Network-related tips and info
- **Horizontal Scroll (KzRRBDzJ):** Use for featured content carousels
- **Message Center (Wm2PoYzK):** Use for ongoing communications (max 100 cards)

---

## Atomic Documentation Links

- **Modal Container:** https://documentation.atomic.io/sdks/ios-swiftui#displaying-modal-container
- **Single Card Container:** https://documentation.atomic.io/sdks/ios-swiftui#displaying-a-single-card-container
- **Horizontal Container:** https://documentation.atomic.io/sdks/ios-swiftui#displaying-a-horizontal-container
- **Stream Container (Vertical):** https://documentation.atomic.io/sdks/ios-swiftui#displaying-a-vertical-container

---

## Theme Configuration

All containers use:
- **Theme:** Atomic - Light
- **Brand Colors:**
  - Primary: Insurance Pink (rgb(233, 51, 117))
  - Secondary: Insurance Blue (rgb(31, 120, 217))
- **API Host:** https://512-1.customer-api.atomic.io/BJelgDpV

---

## Maintenance History

| Date | Change | Author |
|------|--------|--------|
| Oct 30, 2025 | Initial mapping from CSV | Claude Code |
| Oct 30, 2025 | Verified all IDs implemented | Claude Code |

---

## Related Documents

- `AtomicConfiguration.swift` - Container ID definitions
- `AtomicSwiftUIContainers.swift` - Container implementations
- `container_ids.csv` - Source CSV file (backup copy)
- `ATOMIC_IMPROVEMENTS_REPORT.md` - Implementation analysis

---

*Reference document for Demo Insurance Atomic SDK integration*
*Organization: 512-1 | Environment: BJelgDpV*
