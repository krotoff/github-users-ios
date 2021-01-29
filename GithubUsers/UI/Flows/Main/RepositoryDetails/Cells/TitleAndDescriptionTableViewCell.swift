//
//  TitleAndDescriptionTableViewCell.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

final class TitleAndDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    static let identifier = String(describing: TitleAndDescriptionTableViewCell.self)
    
    // MARK: - Private properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let titleLabel = UILabel()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    // MARK: - Internal methods
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    static func cellHeight(forWidth width: CGFloat, text: String) -> CGFloat {
        let width: CGFloat = width - (16 * 2)
        let font: UIFont = .systemFont(ofSize: 17)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        // 21 - titleLabel height, 8 - stack view constraints, 16 - stack view spacing
        return ceil(boundingBox.height) + 21 + 8 * 2 + 16
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        contentView.addSubview(mainStackView)
        
        mainStackView.applyConstraintsInSuperview(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), useSafeArea: true)
    }
}
