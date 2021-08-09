//
//  HttpPostClient.swift
//  Data
//
//  Created by Pedro Silva Dos Santos on 09/08/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void)
}
