//
//  QuotesRepository.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import Observable

enum QuotesRepositoryEvent {
    case onInitialized
    case onUpdated(inserted: Set<QuoteModel>, updated: Set<QuoteModel>)
    case onCleared
}

protocol QuotesRepositoryProtocol {

    var events: Observable<QuotesRepositoryEvent> { get }

    func subscribe(tickers: [String])
    func getAll() -> [QuoteModel]
    func removeAll()
}

final class QuotesRepository {

    struct Dependencies {
        let storage: QuotesStorageProtocol
        let commandBuilder: SocketCommandBuilderProtocol
        let socketSender: SocketCommandSenderProtocol
        let socketPublisher: SocketPublisherProtocol
        let socketParser: SocketParserProtocol
    }

    private let dependencies: Dependencies

    private let queue = DispatchQueue(label: "quotes-repository.queue", attributes: .concurrent)
    private let internalEvents = MutableObservable(QuotesRepositoryEvent.onInitialized)
    private var disposal = Disposal()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    private func innerUpdate(items: [QuoteResponseModel]) {
        dependencies.storage.update(items: items) { [weak self] (_ updatedResult: QuotesStorageUpdated) in
            self?.queue.async {
                self?.internalEvents.wrappedValue = .onUpdated(inserted: updatedResult.inserted, updated: updatedResult.updated)
            }
        }
    }

    private func processSocketData(data: Data) {
        guard let response = dependencies.socketParser.makeResponseModel(data: data) else { return }
        if case .quote(let model) = response {
            innerUpdate(items: [model])
        }
    }

    private func unsubscribe() {
        disposal.dispose()
    }

    private func subscribe() {
        dependencies.socketPublisher.events.observe(queue) { [weak self] (event: Socket.Event, _) in
            if case let .onDataReceived(data) = event {
                self?.processSocketData(data: data)
            }
        }.add(to: &disposal)
    }
}

extension QuotesRepository: QuotesRepositoryProtocol {

    var events: Observable<QuotesRepositoryEvent> {
        return internalEvents
    }

    func subscribe(tickers: [String]) {
        guard let command = dependencies.commandBuilder.makeQuotesSubscribe(tickers: tickers) else { return }
        dependencies.storage.removeAll()
        dependencies.socketSender.send(command: command)
    }

    func removeAll() {
        dependencies.storage.removeAll()
        internalEvents.wrappedValue = .onCleared
    }

    func getAll() -> [QuoteModel] {
        dependencies.storage.getAll()
    }
}
