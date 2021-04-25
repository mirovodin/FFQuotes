//
//  QuotesModuleViewState.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

enum QuotesModuleViewState {
    case initial
    case fullUpdate(viewModel: QuotesModuleViewModel)
    case update(viewModel: QuotesModuleViewModel)
    case emptyResult(message: String)
}
