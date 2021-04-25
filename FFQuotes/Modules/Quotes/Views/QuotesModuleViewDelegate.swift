//
//  QuotesModuleViewDelegate.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import UIKit

protocol QuotesModuleViewDelegateProtocol: UITableViewDelegate { }

final class QuotesModuleViewDelegate: NSObject {
    var onSelectedRow: ((Int) -> ())?
}

extension QuotesModuleViewDelegate: QuotesModuleViewDelegateProtocol {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectedRow?(indexPath.row)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuotesModuleViewHeaderView.identifier)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuotesModuleViewFooterView.identifier)
        return footer
    }
}
