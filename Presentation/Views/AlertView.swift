//
//  AlertView.swift
//  Presentation
//
//  Created by Pedro Silva Dos Santos on 31/08/21.
//

import Foundation

public protocol AlertViewProtocol {
    func showMenssage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable {
    public var title: String
    public var message: String
    
    public init (title: String, message: String) {
        self.title = title
        self.message = message
    }
}
