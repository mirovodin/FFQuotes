//
//  QuotesModuleInteractor.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import Observable

protocol QuotesModuleInteractorProtocol {
    func requestQuotes()
    func stopQuotes()
}

final class QuotesModuleInteractor {

    private enum Constants {
        static let tickers = ["RSTI","GAZP","MRKZ","RUAL","HYDR","MRKS","SBER","FEES","TGKA","VTBR","ANH.US","VICL.US","BURG.US","NBL.US","YETI.US","WSFS.US","NIO.US","DXC.US","MIC.US","HSBC.US","EXPN.EU","GSK.EU","SHP.EU","MAN.EU","DB1.EU","MUV2.EU","TATE.EU","KGF.EU","MGGT.EU","SGGD.EU"]
    }

    private let presenter: QuotesModulePresenterProtocol
    private let repository: QuotesRepositoryProtocol
    private let socketStatus: SocketStatusProvider
    private let networkStatus: NetworkStatusProvider

    private var disposal = Disposal()

    init(repository: QuotesRepositoryProtocol, socketStatus: SocketStatusProvider, networkStatus: NetworkStatusProvider, presenter: QuotesModulePresenterProtocol) {
        self.presenter = presenter
        self.repository = repository
        self.socketStatus = socketStatus
        self.networkStatus = networkStatus
        subscribe()
    }

    private func subscribe() {
        socketStatus.status.observe { [weak self] (status: Socket.Status, _) in
            if case .onDisconnected = status {
                self?.processDisconnected()
            }

        }.add(to: &disposal)

        repository.events.observe { [weak self] (event: QuotesRepositoryEvent, _) in
            switch event {
                case .onUpdated(_, let updated):
                    self?.processUpdate(updated: updated)
                case .onEmpty:
                    self?.processEmpty()
                default:
                    break
            }
        }.add(to: &disposal)
    }

    private func processEmpty() {
        presenter.presentEmpty()
    }

    private func processDisconnected() {
        if !networkStatus.isNetworkReachable {
            presenter.presentNetworkError()
        }
    }

    private func processUpdate(updated: Set<QuoteModel>) {
        let model = makeItems()
        if model.isEmpty {
            processEmpty()
        } else {
            var updatedIndexes = Set<Int>()
            if !updated.isEmpty {
                for (index, element) in model.enumerated() {
                    if updated.contains(element) {
                        updatedIndexes.insert(index)
                    }
                }
            }
            presenter.present(model: model, updatedIndexes: updatedIndexes)
        }
    }

    private func makeItems() -> [QuoteModel] {
        let model = repository.getAll().sorted(by: { $0.ticker > $1.ticker })
        return model
    }

    private func unsubscribe() {
        disposal.dispose()
    }

    deinit {
        unsubscribe()
    }
}

extension QuotesModuleInteractor: QuotesModuleInteractorProtocol {

    func requestQuotes() {
        processUpdate(updated: Set<QuoteModel>())
        repository.subscribe(tickers: Constants.tickers)
    }

    func stopQuotes() {
        unsubscribe()
    }
}
