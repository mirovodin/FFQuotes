//
//  QuotesModulePresenter.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation

protocol QuotesModulePresenterProtocol {
    func present(model: [QuoteModel], updatedIndexes: Set<Int>)
    func presentEmpty()
}

final class QuotesModulePresenter {
    weak var view: QuotesModuleViewProtocol?

    private let formatters: FormattersProtocol
    private let tickerIconsFactory: TickerIconsFactoryProtocol

    init(formatters: FormattersProtocol, tickerIconsFactory: TickerIconsFactoryProtocol) {
        self.formatters = formatters
        self.tickerIconsFactory = tickerIconsFactory
    }
}

extension QuotesModulePresenter: QuotesModulePresenterProtocol {

    func present(model: [QuoteModel], updatedIndexes: Set<Int>) {
        let items: [QuoteViewModel] = model.map { (item: QuoteModel) -> QuoteViewModel in
            let tickerIconUrl = tickerIconsFactory.makeTickerIconUrl(ticker: item.ticker)
            return .init(model: item, tickerIconUrl: tickerIconUrl, formatters: formatters)
        }

        let viewModel = QuotesModuleViewModel(items: items, updatedIndexes: updatedIndexes)

        let viewState: QuotesModuleViewState

        if updatedIndexes.isEmpty {
            viewState = QuotesModuleViewState.fullUpdate(viewModel: viewModel)
        } else {
            viewState = QuotesModuleViewState.update(viewModel: viewModel)
        }

        DispatchQueue.main.async { [weak self] in
            self?.view?.displayViewState(viewState: viewState)
        }
    }

    func presentEmpty() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.displayViewState(viewState: .emptyResult(message: "List is empty"))
        }
    }
}
