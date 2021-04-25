//
//  QuotesModuleViewDataSource.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import UIKit

protocol QuotesModuleViewDataSourceProtocol: UITableViewDataSource {
    var model: QuotesModuleViewModel? { get set }
}

final class ScheduleViewDataSource: NSObject {
    var model: QuotesModuleViewModel?
}

extension ScheduleViewDataSource: QuotesModuleViewDataSourceProtocol {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuotesModuleViewQuoteCell.identifier) as! QuotesModuleViewQuoteCell
        let rowIndex = indexPath.row
        if let item = model?.items[rowIndex] {
            let isUpdated = model?.updatedIndexes.contains(rowIndex) ?? false
            let model = QuoteCellViewModel(model: item, isUpdated: isUpdated)
            cell.configure(model: model)
        }

        return cell
    }

}
