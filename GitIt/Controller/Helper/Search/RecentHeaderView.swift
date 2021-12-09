//
//  RecentsViewProvider.swift
//  GitIt
//
//  Created by Loay Ashraf on 23/11/2021.
//

import Foundation
import UIKit

class HistoryHeaderView: UIView {
    
    private var clearAction: (() -> Void)!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    class func instanceFromNib() -> HistoryHeaderView {
        let view = UINib(nibName: "RecentHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HistoryHeaderView
        view.configureUI()
        return view
    }
    
    private func configureUI() {
        collectionView.register(RecentsCollectionViewCell.nib, forCellWithReuseIdentifier: RecentsCollectionViewCell.reuseIdentifier)
    }
    
    @IBAction func clearHistory (_ sender: UIButton) {
        clearAction()
    }
    
    func configureDelegate(delegate: UIViewController) {
        collectionView.delegate = delegate as? UICollectionViewDelegate
    }
    
    func configureDataSource(dataSource: UIViewController) {
        collectionView.dataSource = dataSource as? UICollectionViewDataSource
    }
    
    func configureButtonAction(action: @escaping () -> Void) {
        clearAction = action
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showCollectionView() {
        collectionView.isHidden = false
    }
    
    func hideCollectionView() {
        collectionView.isHidden = true
    }
    
}
