//
//  HistoryHeaderView.swift
//  GitIt
//
//  Created by Loay Ashraf on 23/11/2021.
//

import Foundation
import UIKit

class HistoryHeaderView: UIView {
    
    private var clearAction: (() -> Void)!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    class func instanceFromNib() -> HistoryHeaderView {
        let view = UINib(nibName: "HistoryHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HistoryHeaderView
        view.configureUI()
        return view
    }
    
    @IBAction func clearHistory (_ sender: UIButton) {
        clearAction()
    }
    
    private func configureUI() {
        collectionView.register(HistoryCollectionViewCell.nib, forCellWithReuseIdentifier: HistoryCollectionViewCell.reuseIdentifier)
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
    
    func deleteItems(at indexpaths: [IndexPath]) {
        collectionView.deleteItems(at: indexpaths)
    }
    
    func showCollectionView() {
        collectionView.isHidden = false
    }
    
    func hideCollectionView() {
        collectionView.isHidden = true
    }
    
}
