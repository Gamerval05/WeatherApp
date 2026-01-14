import UIKit

final class ErrorView: UIView {

    // MARK: - UI

    private let titleLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    // MARK: - Callbacks

    var onRetry: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func show(message: String) {
        titleLabel.text = message
        isHidden = false
    }

    func hide() {
        isHidden = true
    }

    // MARK: - Setup

    private func setupUI() {
        isHidden = true
        backgroundColor = UIColor.systemBackground

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        retryButton.setTitle(L10n.retry, for: .normal)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}
