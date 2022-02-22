//
//  DPSFDynamicCollectionView.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFDynamicCollectionView: CollectionView, DPStatefulView {

    // MARK: - Properties
    
    var state: ViewState = .presenting

    private var emptyView: EmptyView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
    
    func showEmpty(for model: EmptyViewModel) {
        emptyView.show(on: self, with: model)
    }
    
    func hideEmpty() {
        emptyView.hide()
    }
    
}
