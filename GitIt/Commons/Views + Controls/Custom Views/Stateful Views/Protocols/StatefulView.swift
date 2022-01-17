//
//  StatefulView.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

protocol StatefulView: UIView {
    
    var state: ViewState { get set }
    
    func transition(to viewState: ViewState)
    func render(_ viewState: ViewState)
    func showActivityIndicator(for loadingViewState: LoadingViewState)
    func hideActivityIndicator(for loadingViewState: LoadingViewState)
    func showError(for failedViewState: FailedViewState)
    func hideError(for failedViewState: FailedViewState)
    
}
