import Foundation
import UIKit

internal class TableViewCell: UITableViewCell {
    
    // MARK: UI elements
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .horizontal
        return view
    }()
    
    internal lazy var photoView: UIImageView = {
        let photo = UIImageView()
        photo.backgroundColor = .gray
        return photo
    }()
    
    internal lazy var titleLabel: UILabel = {
        return UILabel()
    }()
    
    internal lazy var cuisineLabel: UILabel = {
        return UILabel()
    }()
        
    // MARK: Internal properties
    
    internal var currentTask: Task<Void, Error>?
    
    // MARK: Private properties
        
    // MARK: Internal methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentTask?.cancel()
        currentTask = nil
        photoView.image = nil
    }
    
    internal func configure(title: String, cuisine: String?) {
        self.titleLabel.text = title
        self.cuisineLabel.text = cuisine
        
        setupSubviews()
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        photoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true

        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(photoView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(cuisineLabel)
        stackView.setCustomSpacing(5, after: photoView)
    }
}

// MARK: - UITableViewCell extension

//* Allows for population of a placeholder tableViewCell
extension UITableViewCell {
    convenience init(text: String) {
        self.init(style: .default, reuseIdentifier: nil)
        self.textLabel?.text = text
        self.textLabel?.numberOfLines = 0
    }
}
