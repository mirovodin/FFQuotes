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
        configurePlaceholderView(informationView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.requestQuotes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.stopQuotes()
    }

    private func configurePlaceholderView(_ placeholder: UIView) {
        view.addSubview(placeholder)
        placeholder.backgroundColor = palette.getColor(.background)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        placeholder.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        placeholder.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        placeholder.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        placeholder.isHidden = true
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
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
    }

    private func displayInformation(title: String, image: UIImage?) {
        view.bringSubviewToFront(informationView)
        informationView.configure(title: title, image: image)
        informationView.isHidden = false
    }

    private func displayUpdate(viewModel: QuotesModuleViewModel) {
        dataSource.model = viewModel
        tableView.reloadData()
        informationView.isHidden = true
    }
}

extension QuotesModuleView: QuotesModuleViewProtocol {

    func displayViewState(viewState: QuotesModuleViewState) {
        switch viewState {
        case .initial:
            break
        case let .update(viewModel: viewModel):
            displayUpdate(viewModel: viewModel)
        case let .emptyResult(message: message):
            displayInformation(title: message, image: UIImage(named: "empty-list"))
        case let .networkError(message: message):
            displayInformation(title: message, image: UIImage(named: "no-internet"))
        }
    }
}
