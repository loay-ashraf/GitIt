//
//  DPSFDynamicTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFDynamicTableView: TableView, DPStatefulView {
    
    // MARK: - Properties
    
    var state: ViewState = .presenting
    
    private var emptyView: EmptyView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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
        case .presenting: reloadData()
        case .empty(let emptyContext): showEmpty(for: emptyContext)
        default: break
        }
    }
    
    func showEmpty(for viewModel: EmptyViewModel) {
        emptyView.show(on: self, with: viewModel)
        isScrollEnabled = false
    }
    
    func hideEmpty() {
        emptyView.hide()
        isScrollEnabled = true
    }
    
}
