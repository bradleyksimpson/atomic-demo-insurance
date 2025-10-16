import SwiftUI

struct ChatbotView: View {
    @Environment(\.dismiss) var dismiss
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isTyping = false
    
    init() {
        _messages = State(initialValue: [
            ChatMessage(
                text: "Hi! I'm Maya, your AI insurance assistant 🤖\n\nI can help you with:\n• Getting quotes\n• Filing claims\n• Policy questions\n• And much more!",
                isUser: false,
                timestamp: Date(),
                options: [
                    ChatMessage.ChatOption(text: "Get a quote", action: {}),
                    ChatMessage.ChatOption(text: "File a claim", action: {}),
                    ChatMessage.ChatOption(text: "View policies", action: {})
                ]
            )
        ])
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages) { message in
                                ChatBubble(message: message) { option in
                                    handleOptionTap(option)
                                }
                                .id(message.id)
                            }
                            
                            if isTyping {
                                TypingIndicator()
                                    .id("typing")
                            }
                        }
                        .padding()
                    }
                    .background(Theme.backgroundGray)
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(isTyping ? "typing" : messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Input area
                HStack(spacing: 12) {
                    TextField("Ask me anything...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(inputText.isEmpty ? Color.gray : Theme.primaryPink)
                    }
                    .disabled(inputText.isEmpty)
                }
                .padding()
                .background(Color.white)
            }
            .navigationTitle("Maya AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func sendMessage() {
        let userMessage = ChatMessage(
            text: inputText,
            isUser: true,
            timestamp: Date(),
            options: nil
        )
        
        messages.append(userMessage)
        inputText = ""
        
        // Simulate typing
        isTyping = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            
            let response = generateResponse(for: userMessage.text)
            messages.append(response)
        }
    }
    
    func handleOptionTap(_ option: ChatMessage.ChatOption) {
        // Add user's selection as a message
        let userMessage = ChatMessage(
            text: option.text,
            isUser: true,
            timestamp: Date(),
            options: nil
        )
        messages.append(userMessage)
        
        // Generate response based on option
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isTyping = false
            let response = generateResponse(for: option.text)
            messages.append(response)
        }
    }
    
    func generateResponse(for input: String) -> ChatMessage {
        let lowercased = input.lowercased()
        
        if lowercased.contains("quote") {
            return ChatMessage(
                text: "Great! Let's get you a quote in 90 seconds ⚡\n\nWhat would you like to insure?",
                isUser: false,
                timestamp: Date(),
                options: [
                    ChatMessage.ChatOption(text: "🏠 Home", action: {}),
                    ChatMessage.ChatOption(text: "🚗 Car", action: {}),
                    ChatMessage.ChatOption(text: "🐕 Pet", action: {})
                ]
            )
        } else if lowercased.contains("claim") {
            return ChatMessage(
                text: "I'm sorry to hear that! Let's get your claim started.\n\nWhat type of claim would you like to file?",
                isUser: false,
                timestamp: Date(),
                options: [
                    ChatMessage.ChatOption(text: "📸 Upload photos", action: {}),
                    ChatMessage.ChatOption(text: "📝 Describe incident", action: {}),
                    ChatMessage.ChatOption(text: "📞 Call agent", action: {})
                ]
            )
        } else if lowercased.contains("home") || lowercased.contains("house") {
            return ChatMessage(
                text: "Perfect! Home insurance it is 🏠\n\nI'll need some basic info:\n• Your address\n• Home type (house, condo, etc.)\n• Approximate home value\n\nWould you like to continue?",
                isUser: false,
                timestamp: Date(),
                options: [
                    ChatMessage.ChatOption(text: "Continue", action: {}),
                    ChatMessage.ChatOption(text: "Learn more", action: {})
                ]
            )
        } else {
            return ChatMessage(
                text: "I understand! How else can I help you today? 😊",
                isUser: false,
                timestamp: Date(),
                options: [
                    ChatMessage.ChatOption(text: "Get a quote", action: {}),
                    ChatMessage.ChatOption(text: "View policies", action: {}),
                    ChatMessage.ChatOption(text: "Chat with agent", action: {})
                ]
            )
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    let onOptionTap: (ChatMessage.ChatOption) -> Void
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Theme.primaryPink : Color.white)
                    .foregroundColor(message.isUser ? .white : Theme.textPrimary)
                    .cornerRadius(16)
                    .font(.system(size: 16))
                
                if let options = message.options {
                    VStack(spacing: 8) {
                        ForEach(options) { option in
                            Button(action: { onOptionTap(option) }) {
                                Text(option.text)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Theme.primaryPink)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Theme.primaryPink, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Theme.textSecondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: animationAmount
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(16)
            
            Spacer()
        }
        .onAppear {
            animationAmount = 1.2
        }
    }
}

#Preview {
    ChatbotView()
}