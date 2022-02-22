//
//  DPSFStaticTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFStaticTableView: UITableView, DPStatefulView {
    
    var state: ViewState = .presenting
    
    var updateView: (() -> Void)?
    
    // MARK: - Initialisation
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    private func initializeSubviews() { }
    
    // MARK: - View State Methods
    
    func transition(to viewState: ViewState) {
        render(viewState)
    }
    
    func render(_ viewState: ViewState) {
        state = viewState
        switch viewState {
        case .presenting: updateView?()
        default: return
        }
    }
    
}
