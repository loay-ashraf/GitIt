//
//  SearchHistoryViewControllerProtocol.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryDelegate: AnyObject {
    
    func reloadQuery(with query: String)
    func dismissHistoryKeyboard()
    
}
