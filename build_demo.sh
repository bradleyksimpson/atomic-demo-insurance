#!/bin/bash

echo "🏗️  Building Demo Insurance App"
echo "=============================="

# Navigate to project directory
cd "$(dirname "$0")"

# Check if Xcode is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode not found. Please install Xcode to build iOS apps."
    exit 1
fi

echo "✅ Xcode found"

# Check for required files
if [ ! -f "DemoInsurance.xcodeproj/project.pbxproj" ]; then
    echo "❌ Xcode project file not found"
    exit 1
fi

echo "✅ Project files verified"

# Build for iOS Simulator
echo "📱 Building for iOS Simulator..."

xcodebuild \
    -project DemoInsurance.xcodeproj \
    -scheme DemoInsurance \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
    build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Build Successful!"
    echo "==================="
    echo "✅ Demo Insurance app built successfully"
    echo "📱 Ready to run on iOS Simulator"
    echo ""
    echo "Next steps:"
    echo "1. Open DemoInsurance.xcodeproj in Xcode"
    echo "2. Select iPhone 15 Pro simulator"
    echo "3. Press Cmd+R to run"
    echo ""
    echo "Features to test:"
    echo "• AI chatbot (Maya) - tap the pink message bubble"
    echo "• Telematics dashboard - check your driving score"
    echo "• Photo claims - simulate damage assessment"
    echo "• Smart home integration - IoT device monitoring"
    echo "• Policy management - comprehensive coverage overview"
else
    echo ""
    echo "❌ Build Failed"
    echo "=============="
    echo "Check the error messages above and ensure:"
    echo "• All Swift files are properly structured"
    echo "• No syntax errors in the code"
    echo "• Xcode is up to date"
fi