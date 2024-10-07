import UIKit

final class ErrorBanner: UIView {
    
    // MARK: - UI Elements
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Internal properties
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private properties
        
    internal init(errorMessage: String) {
        super.init(frame: .zero)
        setupView(errorMessage: errorMessage)
    }
    
    // MARK: - Internal methods
    
    // MARK: - Private methods
    
    private func setupView(errorMessage: String) {
        self.backgroundColor = .systemPink
        
        messageLabel.text = errorMessage
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBanner))
        messageLabel.addGestureRecognizer(gestureRecognizer)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    @objc private func dismissBanner() {
        self.removeFromSuperview()
    }
}
