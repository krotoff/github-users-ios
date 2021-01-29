//
//  RepositoryDetailsViewController.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit
import RxSwift
import Service

final class RepositoryDetailsViewController: CoordinatableViewController {
    
    // MARK: - Private types
    
    private enum CellKind {
        case titleAndValue(title: String, value: String)
        case titleAndSwitch(title: String, isOn: Bool)
        case titleAndDescription(title: String, description: String)
    }
    
    // MARK: - Private properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.allowsSelection = false
        tableView.register(TitleAndValueTableViewCell.self, forCellReuseIdentifier: TitleAndValueTableViewCell.identifier)
        tableView.register(TitleAndSwitchTableViewCell.self, forCellReuseIdentifier: TitleAndSwitchTableViewCell.identifier)
        tableView.register(TitleAndDescriptionTableViewCell.self, forCellReuseIdentifier: TitleAndDescriptionTableViewCell.identifier)
        
        return tableView
    }()
    
    private var cells = [CellKind]()
    private var viewModel: RepositoryDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    // MARK: - Internal methods
    
    func configure(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.applyConstraintsInSuperview(useSafeArea: true)
    }
    
    private func bind() {
        viewModel.source
            .asDriver(onErrorJustReturn: nil)
            .drive { [weak self] (source: RepositoryDetailsViewModel.ScreenViewModel?) in
                self?.sourceWasUpdated(source)
            }
            .disposed(by: disposeBag)
    }
    
    private func sourceWasUpdated(_ source: RepositoryDetailsViewModel.ScreenViewModel?) {
        guard let source = source else { return }
        
        navigationItem.title = source.name
        
        cells = [
            .titleAndValue(title: "Name", value: source.name),
            .titleAndValue(title: "Size", value: "\(source.size) KB"),
            .titleAndValue(title: "Created at", value: dateFormatter.string(from: source.createdAt)),
            .titleAndValue(title: "Fork", value: String(source.fork)),
            .titleAndSwitch(title: "Like", isOn: source.isLiked)
        ]
        if let description = source.description {
            cells.append(.titleAndDescription(title: "Description", description: description))
        }
        tableView.reloadData()
    }
}

extension RepositoryDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cells.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case let .titleAndValue(title, value):
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndValueTableViewCell.identifier, for: indexPath) as! TitleAndValueTableViewCell
            cell.configure(title: title, value: value)
            
            return cell
        case let .titleAndSwitch(title, isOn):
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndSwitchTableViewCell.identifier, for: indexPath) as! TitleAndSwitchTableViewCell
            cell.configure(title: title, isLiked: isOn) { [weak self] isLiked in
                self?.viewModel.changeLikeState(isLiked: isLiked)
            }
            
            return cell
        case let .titleAndDescription(title, description):
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleAndDescriptionTableViewCell.identifier, for: indexPath) as! TitleAndDescriptionTableViewCell
            cell.configure(title: title, description: description)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case let .titleAndDescription(_, description):
            return TitleAndDescriptionTableViewCell.cellHeight(forWidth: tableView.bounds.width, text: description)
        case .titleAndSwitch, .titleAndValue:
            return 60
        }
    }
}

extension RepositoryDetailsViewController: UITableViewDelegate {
    
}
