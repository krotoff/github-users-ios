//
//  TitleAndValueTableViewCell.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

final class TitleAndValueTableViewCell: UITableViewCell {
    
    // MARK: - Internal properties
    
    static let identifier = String(describing: TitleAndValueTableViewCell.self)
    
    // MARK: - Private properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let titleLabel = UILabel()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .semibold)
        
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
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    // MARK: - Private methods
    
    private func initialize() {
        contentView.addSubview(mainStackView)
        
        mainStackView.applyConstraintsInSuperview(with: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16), useSafeArea: true)
    }
}
