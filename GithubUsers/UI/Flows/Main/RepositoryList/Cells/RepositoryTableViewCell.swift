//
//  RepositoryTableViewCell.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    static let identifier = String(describing: RepositoryTableViewCell.self)
    
    // MARK: - Private properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, likeSwitch])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let likeSwitch = UISwitch()
    private var changedLikeState: ((Bool) -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        likeSwitch.isOn = false
        changedLikeState = nil
    }
    
    // MARK: - Internal methods
    
    func configure(with viewModel: RepositoryListViewModel.CellViewModel, changedLikeState: @escaping ((Bool) -> Void)) {
        titleLabel.text = viewModel.name
        likeSwitch.isOn = viewModel.isLiked
        self.changedLikeState = changedLikeState
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        contentView.addSubview(mainStackView)
        
        mainStackView.applyConstraintsInSuperview(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), useSafeArea: true)
        likeSwitch.addTarget(self, action: #selector(likeStateWasChanged), for: .valueChanged)
    }
    
    @objc private func likeStateWasChanged() {
        changedLikeState?(likeSwitch.isOn)
    }
}
