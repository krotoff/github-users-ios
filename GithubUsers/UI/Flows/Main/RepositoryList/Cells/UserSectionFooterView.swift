//
//  UserSectionFooterView.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

final class UserSectionFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Internal properties
    
    static let identifier = String(describing: UserSectionFooterView.self)
    
    // MARK: - Private properties
    
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var errorView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorLabel, tryAgainButton])
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        
        return view
    }()
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Try again", for: .normal)
        
        return button
    }()
    private var buttonAction: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        errorView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Internal methods
    
    func updateState(isLoading: Bool, error: String?, buttonAction: (() -> Void)?) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        if let error = error {
            errorView.isHidden = false
            errorLabel.text = error
        } else {
            errorView.isHidden = true
        }
        self.buttonAction = buttonAction
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        [errorView, activityIndicator].forEach(contentView.addSubview)
        
        errorView.applyConstraintsInSuperview(with: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), useSafeArea: true)
        activityIndicator.applyCenterConstraints(to: contentView)
        tryAgainButton.applySizeConstantConstraints(with: CGSize(width: 200, height: 40))
        
        tryAgainButton.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
    }
    
    @objc private func buttonWasTapped() {
        buttonAction?()
    }
}
