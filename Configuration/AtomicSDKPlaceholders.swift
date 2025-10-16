import Foundation
import UIKit

// MARK: - Atomic SDK Placeholders for Demo Insurance
// These placeholder implementations allow building without the actual AtomicSDK dependency
// Remove this file when the actual AtomicSDK is added to the project

#if !canImport(AtomicSDK)

// MARK: - Session Management
class AACSession {
    static func setApiBaseUrl(_ url: URL) {
        print("📡 Demo Insurance: Setting API base URL to \(url)")
    }
    
    static func initialise(withEnvironmentId environmentId: String, apiKey: String) {
        print("🚀 Demo Insurance: Initializing Atomic SDK")
        print("   Environment ID: \(environmentId)")
        print("   API Key: \(apiKey)")
    }
    
    static func setSessionDelegate(_ delegate: AACSessionDelegate) {
        print("🔗 Demo Insurance: Setting session delegate: \(type(of: delegate))")
    }
}

// MARK: - Container Views
class AACSingleCardView: UIView {
    init(frame: CGRect, containerIdentifier: String, configuration: AACSingleCardConfiguration) {
        super.init(frame: frame)
        setupPlaceholderContent(containerIdentifier: containerIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholderContent(containerIdentifier: "placeholder")
    }
    
    private func setupPlaceholderContent(containerIdentifier: String) {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Demo Insurance"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Single Card Container"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerIdLabel = UILabel()
        containerIdLabel.text = containerIdentifier
        containerIdLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        containerIdLabel.textColor = .systemBlue
        containerIdLabel.textAlignment = .center
        containerIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(containerIdLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            containerIdLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            containerIdLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8)
        ])
    }
}

class AACStreamContainerViewController: UIViewController {
    init(identifier: String, configuration: AACConfiguration) {
        super.init(nibName: nil, bundle: nil)
        setupPlaceholderContent(identifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholderContent(identifier: "placeholder")
    }
    
    private func setupPlaceholderContent(identifier: String) {
        view.backgroundColor = .systemGray6
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Header
        let headerView = createHeaderView(title: "Demo Insurance Stream", containerID: identifier)
        stackView.addArrangedSubview(headerView)
        
        // Sample cards
        for i in 1...4 {
            let cardView = createInsuranceCardView(
                title: ["Policy Renewal", "Claim Update", "Safety Alert", "Discount Available"][i-1],
                subtitle: ["Due in 30 days", "Under review", "Speeding detected", "15% off available"][i-1],
                icon: ["📋", "📄", "⚠️", "💰"][i-1]
            )
            stackView.addArrangedSubview(cardView)
        }
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func createHeaderView(title: String, containerID: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.layer.cornerRadius = 8
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerLabel = UILabel()
        containerLabel.text = "Container: \(containerID)"
        containerLabel.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        containerLabel.textColor = .secondaryLabel
        containerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(containerLabel)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -8),
            containerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            containerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 8)
        ])
        
        return headerView
    }
    
    private func createInsuranceCardView(title: String, subtitle: String, icon: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.text = "SDK Ready"
        statusLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        statusLabel.textColor = .systemGreen
        statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(iconLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 80),
            
            iconLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            statusLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusLabel.widthAnchor.constraint(equalToConstant: 80),
            statusLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return cardView
    }
}

class AACHorizontalContainerView: UIView {
    init(frame: CGRect, containerIdentifier: String, configuration: AACHorizontalContainerConfiguration) {
        super.init(frame: frame)
        setupPlaceholderContent(containerIdentifier: containerIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlaceholderContent(containerIdentifier: "placeholder")
    }
    
    private func setupPlaceholderContent(containerIdentifier: String) {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Header
        let headerLabel = UILabel()
        headerLabel.text = "Demo Insurance Tips"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerLabel = UILabel()
        containerLabel.text = "Container: \(containerIdentifier)"
        containerLabel.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        containerLabel.textColor = .secondaryLabel
        containerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Sample cards
        let tips = [
            ("Bundle Discount", "Save 20%", "📋"),
            ("Safe Driving", "Lower rates", "🚗"),
            ("Quick Claims", "File fast", "📱")
        ]
        
        for tip in tips {
            let cardView = createTipCard(title: tip.0, subtitle: tip.1, icon: tip.2)
            stackView.addArrangedSubview(cardView)
        }
        
        scrollView.addSubview(stackView)
        addSubview(headerLabel)
        addSubview(containerLabel)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            containerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerLabel.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func createTipCard(title: String, subtitle: String, icon: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.05
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 28)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(iconLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 160),
            cardView.heightAnchor.constraint(equalToConstant: 120),
            
            iconLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            iconLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8)
        ])
        
        return cardView
    }
}

// MARK: - Configuration Classes
class AACSingleCardConfiguration {
    var automaticallyLoadNextCard: Bool = true
    var launchBackgroundColor: UIColor = .systemBackground
    var launchTextColor: UIColor = .label
    var launchLoadingIndicatorColor: UIColor = .systemBlue
    
    init() {}
}

class AACConfiguration {
    var launchBackgroundColor: UIColor = .systemBackground
    var launchTextColor: UIColor = .label
    var launchLoadingIndicatorColor: UIColor = .systemBlue
    
    init() {}
}

class AACHorizontalContainerConfiguration {
    enum ScrollMode {
        case snap
        case continuous
    }
    
    var cardWidth: CGFloat = 300
    var scrollMode: ScrollMode = .snap
    var launchBackgroundColor: UIColor = .systemBackground
    var launchTextColor: UIColor = .label
    var launchLoadingIndicatorColor: UIColor = .systemBlue
    
    init() {}
}

// MARK: - Protocol Definitions
typealias AACSessionAuthenticationTokenHandler = (String) -> Void

protocol AACSessionDelegate {
    func cardSessionDidRequestAuthenticationToken(handler: @escaping AACSessionAuthenticationTokenHandler)
    func cardSessionDidReceiveAction(payload: [String: Any])
}

#endif