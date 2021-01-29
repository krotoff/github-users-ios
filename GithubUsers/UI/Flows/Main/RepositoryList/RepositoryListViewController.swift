//
//  RepositoryListViewController.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit
import RxSwift
import Service

final class RepositoryListViewController: CoordinatableViewController {
    
    // MARK: - Private properties
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.identifier)
        tableView.register(UserSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: UserSectionHeaderView.identifier)
        tableView.register(UserSectionFooterView.self, forHeaderFooterViewReuseIdentifier: UserSectionFooterView.identifier)
        
        return tableView
    }()
    
    private var sections = [RepositoryListViewModel.SectionViewModel]()
    private var viewModel: RepositoryListViewModel!
    private let disposeBag = DisposeBag()
    private let emptyView = UserSectionFooterView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.fetch()
        bind()
    }
    
    // MARK: - Internal methods
    
    func configure(viewModel: RepositoryListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        navigationItem.title = "Repositories"
        
        [tableView, emptyView].forEach(view.addSubview)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        emptyView.applyConstraintsInSuperview()
        tableView.applyConstraintsInSuperview(useSafeArea: true)
        
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
    }
    
    private func bind() {
        viewModel.source
            .asDriver(onErrorJustReturn: .isLoading)
            .drive { [weak self] (sourceState: DataSourceState<RepositoryListViewModel.SectionViewModel>) in
                self?.refreshControl.endRefreshing()
                switch sourceState {
                case .isReady(let sections):
                    self?.sections = sections
                    self?.emptyView.isHidden = true
                case .isLoading:
                    self?.emptyView.isHidden = false
                    self?.emptyView.updateState(isLoading: true, error: nil, buttonAction: nil)
                case .isFailed(let error):
                    self?.emptyView.isHidden = false
                    self?.emptyView.updateState(isLoading: false, error: error.localizedDescription) {
                        self?.viewModel.fetch()
                    }
                }
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func cellsFromSection(_ section: Int) -> [RepositoryListViewModel.CellViewModel] {
        switch sections[section].cells {
        case .isReady(let cells):
            return cells
        case .isLoading, .isFailed:
            return []
        }
    }
    
    @objc private func updateData() {
        viewModel.fetch()
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellsFromSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = cellsFromSection(indexPath.section)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier, for: indexPath) as! RepositoryTableViewCell
        cell.configure(with: cellViewModel) { [weak self] isLiked in
            self?.viewModel.changeLikeState(for: cellViewModel.id, isLiked: isLiked)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = sections[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserSectionHeaderView.identifier) as! UserSectionHeaderView
        headerView.configure(with: sectionViewModel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionViewModel = sections[section]
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserSectionFooterView.identifier) as! UserSectionFooterView
        switch sectionViewModel.cells {
        case .isLoading:
            footerView.updateState(isLoading: true, error: nil, buttonAction: nil)
        case .isFailed(let error):
            footerView.updateState(isLoading: false, error: error.localizedDescription) { [weak self] in
                self?.viewModel.fetchRepositories(of: sectionViewModel.id, urlString: sectionViewModel.reposURL)
            }
        case .isReady:
            return nil
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { 60 }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let sectionViewModel = sections[section]
        switch sectionViewModel.cells {
        case .isLoading, .isFailed:
            return 180
        case .isReady:
            return 0
        }
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        viewModel.showRepositoryDetails(id: cellsFromSection(indexPath.section)[indexPath.row].id, userID: sections[indexPath.section].id)        
    }
}
