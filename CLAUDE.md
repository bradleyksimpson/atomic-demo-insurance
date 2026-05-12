# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iOS demo app showcasing Atomic SDK integration in an insurance context. Used for demoing Atomic to insurance industry prospects. Native Swift/UIKit.

**GitHub:** `bradleyksimpson/atomic-demo-insurance`

## Build & Run

Open `DemoInsurance.xcodeproj` in Xcode. Build and run on iOS Simulator.

- **Target:** DemoInsurance
- **Min iOS:** Check project settings
- **Dependencies:** Atomic SDK (via SPM, conditional import with `#if canImport(AtomicSDK)`)

## Architecture

- `DemoInsurance/Configuration/` — SDK setup, JWT generation (`DemoInsuranceJWTGenerator`), session delegate (`DemoInsuranceAtomicSessionDelegate`)
- Session delegate handles `cardSessionDidRequestAuthenticationToken` (generates JWT with RSA signature) and `cardSessionDidReceiveAction` (routes insurance-specific actions like `file_claim`)

## Atomic SDK Integration Pattern

All Atomic iOS demos follow the same pattern:

1. **Session Delegate** — Implements `AACSessionDelegate`, generates JWT for auth, handles card action payloads
2. **JWT Generator** — RSA-signed JWT with persistent user ID (`sub` claim)
3. **Container Configuration** — Configures Atomic containers (single card, stream, horizontal, toast) with display options
4. **Conditional Imports** — `#if canImport(AtomicSDK)` guards so the project compiles without the SDK framework

## Related Repos

- **Demo Power** — Power/utilities vertical demo
- **DemoWealth** — Wealth management vertical demo (iOS)
- **DemoWealthAndroid** — Wealth management demo (Android/Kotlin)
- **atomic-explore-web** — Web SDK demo (Vite + React)
- **atomic-demos-consolidated** — JSON payload library for demo card content
