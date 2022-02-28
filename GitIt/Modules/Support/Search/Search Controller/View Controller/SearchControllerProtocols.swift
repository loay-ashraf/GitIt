//
//  SearchControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchControllerDelegate: AnyObject {
    
    func didBeginSearchingSession()
    func didEndSearchingSession()
    func willSearch()
    func didSearch()
    
}
