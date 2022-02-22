//
//  DPSFView.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFView: UIView {

    // MARK: - Properties
    
    var state: ViewState = .presenting
    
    var updateView: (() -> Void)?

    private var emptyView: EmptyView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    private func initializeSubviews() {
        emptyView = EmptyView.instanceFromNib()
    }
    
    // MARK: - View State Methods
    
    func transition(to viewState: ViewState) {
        switch state {
        case .empty: hideEmpty()
        default: break
        }
        render(viewState)
    }
    
    func render(_ viewState: ViewState) {
        state = viewState
        switch viewState {
        case .presenting: updateView?()
        case .empty(let emptyContext): showEmpty(for: emptyContext)
        default: break
        }
    }
    
    func showEmpty(for model: EmptyViewModel) {
        emptyView.show(on: self, with: model)
    }
    
    func hideEmpty() {
        emptyView.hide()
    }

}
