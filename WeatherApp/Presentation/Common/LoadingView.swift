

import UIKit

final class LoadingView: UIView {

    // MARK: - UI

    private let activity = UIActivityIndicatorView(style: .large)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func start() {
        isHidden = false
        activity.startAnimating()
    }

    func stop() {
        activity.stopAnimating()
        isHidden = true
    }

    // MARK: - Setup

    private func setupUI() {
        isHidden = true
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)

        activity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activity)

        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
