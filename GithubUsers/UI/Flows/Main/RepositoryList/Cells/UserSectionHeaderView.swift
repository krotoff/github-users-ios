//
//  UserSectionHeaderView.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

final class UserSectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Internal properties
    
    static let identifier = String(describing: UserSectionHeaderView.self)
    
    // MARK: - Private properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, titleLabel])
        stackView.alignment = .center
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        
        return label
    }()
    
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
        
        titleLabel.text = nil
        avatarImageView.image = nil
    }
    
    // MARK: - Internal methods
    
    func configure(with viewModel: RepositoryListViewModel.SectionViewModel) {
        if let imageData = viewModel.imageData {
            avatarImageView.image = UIImage(data: imageData)
        } else {
            avatarImageView.image = nil
        }
        titleLabel.text = viewModel.title
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        contentView.addSubview(mainStackView)
        
        mainStackView.applyConstraintsInSuperview(with: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16), useSafeArea: true)
        avatarImageView
            .applySizeConstantConstraints(at: .y, with: CGSize(width: 0, height: 52))
            .applyAspectRatio(with: 1)
    }
}
