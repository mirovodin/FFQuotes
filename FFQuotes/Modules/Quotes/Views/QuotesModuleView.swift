//
//  QuotesModuleView.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

protocol QuotesModuleViewProtocol: class {
    func displayViewState(viewState: QuotesModuleViewState)
}

final class QuotesModuleView: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    private let interactor: QuotesModuleInteractorProtocol?
    private let delegate: QuotesModuleViewDelegateProtocol
    private let dataSource: QuotesModuleViewDataSourceProtocol

    private lazy var informationView = InformationView.initFromXib()

    init(interactor: QuotesModuleInteractorProtocol?, delegate: QuotesModuleViewDelegateProtocol, dataSource: QuotesModuleViewDataSourceProtocol) {
        self.interactor = interactor
        self.delegate = delegate
        self.dataSource = dataSource
        super.init(nibName: Self.toIdentifier(), bundle: Bundle.main)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = palette.getColor(.background)

        configureTableView()
        configureInformationView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.requestQuotes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.stopQuotes()
    }

    private func configureInformationView() {
        view.addSubview(informationView)
        informationView.backgroundColor = palette.getColor(.background)
        informationView.translatesAutoresizingMaskIntoConstraints = false
        informationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        informationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        informationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        informationView.isHidden = true
    }

    private func configureTableView() {
        let headerNib = UINib(nibName: QuotesModuleViewHeaderView.nibName, bundle: .main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: QuotesModuleViewHeaderView.identifier)

        let footerNib = UINib(nibName: QuotesModuleViewFooterView.nibName, bundle: .main)
        tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: QuotesModuleViewFooterView.identifier)

        let cellNib = UINib(nibName: QuotesModuleViewQuoteCell.nibName, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: QuotesModuleViewQuoteCell.identifier)

        tableView.dataSource = dataSource
        tableView.delegate = delegate

        tableView.backgroundColor = palette.getColor(.background)
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView()
    }

    private func displayInformation(title: String, image: UIImage?) {
        view.bringSubviewToFront(informationView)
        informationView.configure(title: title, image: image)
        informationView.isHidden = false
    }

    private func displayEmpty(title: String) {
        let image = UIImage(systemName: "icloud")
        displayInformation(title: title, image: image)
    }

    private func displayFullUpdate(viewModel: QuotesModuleViewModel) {
        dataSource.model = viewModel
        tableView.reloadData()
        informationView.isHidden = true
    }

    private func displayUpdate(viewModel: QuotesModuleViewModel) {
        let indexes = viewModel.updatedIndexes.map { IndexPath(row: $0, section: 0) }
        dataSource.model = viewModel
        tableView.reloadRows(at: indexes, with: .fade)
        informationView.isHidden = true
    }
}

extension QuotesModuleView: QuotesModuleViewProtocol {

    func displayViewState(viewState: QuotesModuleViewState) {
        switch viewState {
        case .initial:
            break
        case let .fullUpdate(viewModel: viewModel):
            displayFullUpdate(viewModel: viewModel)
        case let .update(viewModel: viewModel):
            displayUpdate(viewModel: viewModel)
        case let .emptyResult(message: message):
            displayEmpty(title: message)
        }
    }
}
