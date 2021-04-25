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

    private var interactor: QuotesModuleInteractor?
    private var moduleView: UIViewController?
    private let repository: QuotesRepositoryProtocol
    private let formatters: FormattersProtocol
    private let tickerIconsFactory: TickerIconsFactoryProtocol

    init(repository: QuotesRepositoryProtocol, formatters: FormattersProtocol, tickerIconsFactory: TickerIconsFactoryProtocol) {
        self.repository = repository
        self.formatters = formatters
        self.tickerIconsFactory = tickerIconsFactory
    }

    // MARK: - Presentable
    func toPresent() -> UIViewController? {
        let presenter = QuotesModulePresenter(formatters: formatters, tickerIconsFactory: tickerIconsFactory)

        let dataSource = ScheduleViewDataSource()
        let delegate = QuotesModuleViewDelegate()
        interactor = QuotesModuleInteractor(repository: repository, presenter: presenter)

        let view = QuotesModuleView(interactor: interactor, delegate: delegate, dataSource: dataSource)
        presenter.view = view
        moduleView = view
        return view
    }
}
