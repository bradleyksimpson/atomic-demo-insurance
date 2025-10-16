import Foundation
import UIKit

// Conditional imports - only when SDK is actually added
#if canImport(AtomicSDK)
import AtomicSDK

// MARK: - Demo Insurance Atomic Session Delegate
class DemoInsuranceAtomicSessionDelegate: NSObject, AACSessionDelegate {
    func cardSessionDidRequestAuthenticationToken(handler: @escaping AACSessionAuthenticationTokenHandler) {
        let startTime = CFAbsoluteTimeGetCurrent()
        NSLog("🔐 Demo Insurance: AUTHENTICATION REQUEST RECEIVED at \(Date())")
        NSLog("🔍 Generating JWT with persistent user ID...")

        let jwt = DemoInsuranceJWTGenerator.generateJWTWithRSASignature()

        let elapsedTime = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
        NSLog("⏱️ JWT generation took %.2f ms", elapsedTime)

        if !jwt.isEmpty {
            NSLog("✅ Demo Insurance: JWT generated successfully")
            NSLog("🔐 FULL JWT: %@", jwt)

            let components = jwt.components(separatedBy: ".")
            if components.count >= 2 {
                NSLog("🔐 JWT Header: %@", components[0])
                NSLog("🔐 JWT Payload: %@", components[1])
            }

            NSLog("🔐 AUTHENTICATION COMPLETED - calling handler")
            NSLog("📋 User will be registered via JWT 'sub' claim")
            handler(jwt)
            NSLog("✅ Handler called successfully with JWT")
        } else {
            NSLog("❌ Demo Insurance: JWT generation failed - calling handler with nil")
            handler(nil)
            NSLog("❌ Handler called with nil")
        }
    }

    // MARK: - SDK Protocol Method
    func cardSessionDidReceiveAction(payload: [String: Any]) {
        NSLog("🎯 ===== DEMO INSURANCE SESSION DELEGATE =====")
        NSLog("🎯 Received card action payload: %@", payload as NSDictionary)
        NSLog("🔍 Payload keys: %@", Array(payload.keys))

        // Handle insurance-specific card actions
        if let actionType = payload["actionType"] as? String {
            switch actionType {
            case "file_claim":
                handleFileClaimAction(payload: payload)
            case "view_policy":
                handleViewPolicyAction(payload: payload)
            case "request_quote":
                handleRequestQuoteAction(payload: payload)
            case "safety_score":
                handleSafetyScoreAction(payload: payload)
            case "payment_reminder":
                handlePaymentReminderAction(payload: payload)
            case "roadside_assistance":
                handleRoadsideAssistanceAction(payload: payload)
            default:
                print("🔍 Demo Insurance: Unknown action type: \(actionType)")
            }
        }

        // Analytics tracking
        trackInsuranceAction(payload: payload)

        NSLog("✅ Card action payload processed")
        NSLog("====================================")
    }

    // MARK: - Insurance-specific Action Handlers
    private func handleFileClaimAction(payload: [String: Any]) {
        print("📋 Demo Insurance: Handling file claim action")

        if let claimType = payload["claimType"] as? String {
            print("   Claim Type: \(claimType)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToClaimsFlow"),
                object: payload
            )
        }
    }

    private func handleViewPolicyAction(payload: [String: Any]) {
        print("📄 Demo Insurance: Handling view policy action")

        if let policyId = payload["policyId"] as? String {
            print("   Policy ID: \(policyId)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToPolicy"),
                object: payload
            )
        }
    }

    private func handleRequestQuoteAction(payload: [String: Any]) {
        print("💰 Demo Insurance: Handling request quote action")

        if let insuranceType = payload["insuranceType"] as? String {
            print("   Insurance Type: \(insuranceType)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToQuote"),
                object: payload
            )
        }
    }

    private func handleSafetyScoreAction(payload: [String: Any]) {
        print("🏆 Demo Insurance: Handling safety score action")

        if let score = payload["score"] as? Int {
            print("   Safety Score: \(score)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToSafetyScore"),
                object: payload
            )
        }
    }

    private func handlePaymentReminderAction(payload: [String: Any]) {
        print("💳 Demo Insurance: Handling payment reminder action")

        if let amount = payload["amount"] as? Double {
            print("   Amount Due: $\(amount)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToPayment"),
                object: payload
            )
        }
    }

    private func handleRoadsideAssistanceAction(payload: [String: Any]) {
        print("🚗 Demo Insurance: Handling roadside assistance action")

        if let serviceType = payload["serviceType"] as? String {
            print("   Service Type: \(serviceType)")
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("DemoInsuranceNavigateToRoadside"),
                object: payload
            )
        }
    }

    // MARK: - Analytics and Tracking
    private func trackInsuranceAction(payload: [String: Any]) {
        let eventData: [String: Any] = [
            "app": "Demo Insurance",
            "timestamp": Date().timeIntervalSince1970,
            "payload": payload,
            "environment": DemoInsuranceAtomicConfiguration.environmentID
        ]

        print("📊 Demo Insurance: Tracking action event: \(eventData)")
    }
}

// MARK: - Demo Insurance JWT Generator (Real RSA Signing)
class DemoInsuranceJWTGenerator {
    private static var cachedPrivateKey: SecKey?

    static func generateJWTWithRSASignature() -> String {
        NSLog("🔑 Demo Insurance: Generating JWT with REAL RSA256 signature...")

        let currentTime = Int(Date().timeIntervalSince1970)
        let expirationTime = currentTime + 3600 // Valid for 1 hour

        // JWT Header
        let header = [
            "alg": "RS256",
            "kid": "demo-insurance-app-jwt",
            "typ": "JWT"
        ]

        // Get persistent unique user ID for this app installation
        let userID = getUserIDDirect()

        // JWT Payload - Simplified to match working pattern
        let payload = [
            "sub": userID,  // Persistent user ID
            "iat": currentTime,
            "exp": expirationTime,
            "iss": "demo-insurance-app",
            "aud": "atomic-sdk"
        ] as [String: Any]

        // Encode header and payload
        guard let headerData = try? JSONSerialization.data(withJSONObject: header),
              let payloadData = try? JSONSerialization.data(withJSONObject: payload) else {
            NSLog("❌ Demo Insurance: Failed to serialize JWT components")
            return generateFallbackJWT()
        }

        let headerBase64 = base64URLEncode(headerData)
        let payloadBase64 = base64URLEncode(payloadData)
        let signingInput = "\(headerBase64).\(payloadBase64)"

        // Use REAL RSA signing
        if let signature = signWithRSA(signingInput) {
            let jwt = "\(signingInput).\(signature)"

            NSLog("✅ Demo Insurance: JWT generated with REAL RSA signature")
            NSLog("👤 User ID: \(userID)")
            NSLog("🔐 JWT expires at: \(Date(timeIntervalSince1970: TimeInterval(expirationTime)))")

            return jwt
        } else {
            NSLog("❌ Demo Insurance: RSA signing failed, using fallback")
            return generateFallbackJWT()
        }
    }

    // MARK: - Real RSA Signing
    private static func signWithRSA(_ message: String) -> String? {
        NSLog("🔑 signWithRSA called, message length: \(message.count)")

        guard let messageData = message.data(using: .utf8) else {
            NSLog("❌ Failed to convert message to UTF8 data")
            return nil
        }

        // Use cached private key if available
        let privateKey: SecKey
        if let cached = cachedPrivateKey {
            NSLog("🚀 Using cached private key")
            privateKey = cached
        } else {
            // Load private key from file
            NSLog("🔍 Looking for private key in bundle...")
            let bundlePath = Bundle.main.path(forResource: "atomic_demo_private_key", ofType: "pem")
            NSLog("🔍 Bundle path result: \(bundlePath ?? "nil")")

            let privateKeyPath = bundlePath ?? "/Users/bradleysimpson/Demo Insurance/DemoInsurance/Configuration/atomic_demo_private_key.pem"
            NSLog("🔍 Using private key path: \(privateKeyPath)")

            do {
                let privateKeyString = try String(contentsOfFile: privateKeyPath)
                NSLog("✅ Private key file read successfully, length: \(privateKeyString.count)")

                guard let loadedKey = extractPrivateKey(from: privateKeyString) else {
                    NSLog("❌ Failed to extract SecKey from PEM string")
                    return nil
                }

                cachedPrivateKey = loadedKey
                privateKey = loadedKey
                NSLog("✅ Private key loaded and cached successfully")
            } catch {
                NSLog("❌ Failed to load private key from: \(privateKeyPath), error: \(error)")
                return nil
            }
        }

        // Sign the message - SecKeyCreateSignature handles SHA256 internally for RS256
        NSLog("🔐 Attempting RSA signature...")
        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(
            privateKey,
            .rsaSignatureMessagePKCS1v15SHA256,
            messageData as CFData,
            &error
        ) else {
            if let error = error {
                let cfError = error.takeRetainedValue()
                NSLog("❌ RSA signature creation failed: \(cfError)")
                NSLog("❌ Error description: \(CFErrorCopyDescription(cfError) as String?  ?? "unknown")")
            } else {
                NSLog("❌ RSA signature creation failed with no error details")
            }
            return nil
        }

        NSLog("✅ RSA signature created successfully, signature length: \((signature as Data).count)")
        let encodedSig = base64URLEncode(signature as Data)
        NSLog("✅ Base64URL encoded signature length: \(encodedSig.count)")
        return encodedSig
    }

    // MARK: - Extract Private Key from PEM
    private static func extractPrivateKey(from pemString: String) -> SecKey? {
        NSLog("🔑 extractPrivateKey called, PEM length: \(pemString.count)")

        // Remove PEM headers and footers
        let lines = pemString.components(separatedBy: "\n")
        let keyString = lines
            .filter { !$0.hasPrefix("-----") && !$0.isEmpty }
            .joined()

        NSLog("🔍 Base64 key string length: \(keyString.count)")

        guard let keyData = Data(base64Encoded: keyString) else {
            NSLog("❌ Failed to decode base64 key data from string of length \(keyString.count)")
            return nil
        }

        NSLog("✅ Base64 decoded successfully, key data length: \(keyData.count) bytes")

        // Create SecKey from data
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        NSLog("🔐 Creating SecKey with attributes: \(attributes)")

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            if let error = error {
                let cfError = error.takeRetainedValue()
                NSLog("❌ Failed to create private key: \(cfError)")
                NSLog("❌ Error description: \(CFErrorCopyDescription(cfError) as String? ?? "unknown")")
            } else {
                NSLog("❌ Failed to create private key with no error details")
            }
            return nil
        }

        NSLog("✅ SecKey created successfully")
        return privateKey
    }

    // MARK: - Base64 URL Encoding
    private static func base64URLEncode(_ data: Data) -> String {
        return data.base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

    private static func generateFallbackJWT() -> String {
        NSLog("⚠️ Demo Insurance: Using fallback JWT generation")

        let currentTime = Int(Date().timeIntervalSince1970)
        let userID = getUserIDDirect()

        let fallbackPayload: [String: Any] = [
            "sub": userID,
            "iat": currentTime,
            "exp": currentTime + 3600,
            "iss": "demo-insurance-app",
            "aud": "atomic-sdk"
        ]

        guard let payloadData = try? JSONSerialization.data(withJSONObject: fallbackPayload) else {
            return "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8taW5zdXJhbmNlLWFwcC1qd3QiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJpbnN1cmFuY2UtdXNlci1URVNUMTIzIiwiaWF0IjoxNjAwMDAwMDAwLCJleHAiOjE2MDAwMDM2MDB9.demo-insurance-signature"
        }

        let payloadBase64 = base64URLEncode(payloadData)
        return "eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlbW8taW5zdXJhbmNlLWFwcC1qd3QiLCJ0eXAiOiJKV1QifQ.\(payloadBase64).demo-insurance-signature"
    }

    // MARK: - Direct User ID Access (Persistent User IDs)
    static func getUserIDDirect() -> String {
        let userIDKey = "atomic_user_id_insurance"

        // Try UserDefaults first
        if let existingID = UserDefaults.standard.string(forKey: userIDKey),
           !existingID.isEmpty && isValidUserIDFormat(existingID) {
            return existingID
        }

        // Generate new unique ID
        let uuid = UUID()
        let hexString = uuid.uuidString.replacingOccurrences(of: "-", with: "").prefix(8).uppercased()
        let userID = "insurance-user-\(hexString)"

        UserDefaults.standard.set(userID, forKey: userIDKey)
        NSLog("👤 Generated new persistent user ID: \(userID)")

        return userID
    }

    private static func isValidUserIDFormat(_ userID: String) -> Bool {
        let pattern = "^insurance-user-[A-F0-9]{8}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: userID.utf16.count)
        return regex?.firstMatch(in: userID, options: [], range: range) != nil
    }
}

#endif
