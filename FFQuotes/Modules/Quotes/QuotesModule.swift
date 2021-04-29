//
//  QuotesModule.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

protocol QuotesModuleProtocol: Presentable {

}

final class QuotesModule: QuotesModuleProtocol {

    struct Dependencies {
        let repository: QuotesRepositoryProtocol
        let formatters: FormattersProtocol
        let iconsFactory: TickerIconsFactoryProtocol
        let socketStatus: SocketStatusProvider
        let networkStatus: NetworkStatusProvider
    }

    private var interactor: QuotesModuleInteractor?
    private var moduleView: UIViewController?
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Presentable
    func toPresent() -> UIViewController? {
        let presenter = QuotesModulePresenter(formatters: dependencies.formatters,
                                              tickerIconsFactory: dependencies.iconsFactory)

        let dataSource = ScheduleViewDataSource()
        let delegate = QuotesModuleViewDelegate()
        interactor = QuotesModuleInteractor(repository: dependencies.repository,
                                            socketStatus: dependencies.socketStatus,
                                            networkStatus: dependencies.networkStatus,
                                            presenter: presenter)

        let view = QuotesModuleView(interactor: interactor, delegate: delegate, dataSource: dataSource)
        presenter.view = view
        moduleView = view
        return view
    }
}
