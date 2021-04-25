//
//  QuotesStorage.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import Foundation

typealias QuotesStorageUpdateResult = ()

struct QuotesStorageUpdated {
    let inserted: Set<QuoteModel>
    let updated: Set<QuoteModel>
}

protocol QuotesStorageProtocol {
    func getAll() -> [QuoteModel]
    func getById(tickerId: String) -> QuoteModel?
    func removeAll()
    func update(items: [QuoteResponseModel], completion: @escaping (_ updated: QuotesStorageUpdated) -> Void)
}

final class QuotesStorage {
    private var storage = [String: QuoteModel]()
    private let queue = DispatchQueue(label: "quotes-storage.queue", attributes: .concurrent)
}

extension QuotesStorage: QuotesStorageProtocol  {

    func getAll() -> [QuoteModel] {
        return queue.sync {
            return Array(storage.values)
        }
    }

    func getById(tickerId: String) -> QuoteModel? {
        return queue.sync {
            return storage[tickerId]
        }
    }

    func removeAll() {
        queue.async(flags: .barrier) { [weak self] in
            self?.storage.removeAll()
        }
    }

    func update(items: [QuoteResponseModel], completion: @escaping (_ updated: QuotesStorageUpdated) -> Void) {
        var inserted = Set<QuoteModel>()
        var updated = Set<QuoteModel>()

        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            items.forEach { (item) in
                let existsModel = self.storage[item.ticker]
                let model = QuoteModel(response: item, model: existsModel)
                self.storage[item.ticker] = model
                if existsModel != nil {
                    updated.insert(model)
                } else {
                    inserted.insert(model)
                }
            }
            let result = QuotesStorageUpdated(inserted: inserted, updated: updated)
            completion(result)
        }
    }
}
