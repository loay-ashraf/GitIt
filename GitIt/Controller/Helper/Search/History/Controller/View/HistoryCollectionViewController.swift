//
//  HistoryCollectionViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class HistoryCollectionViewController: SFDynamicCollectionViewController<Any> {

    override var model: List<Any>! { return delegate?.models }
    override var cellConfigurator: CollectionViewCellConfigurator! { return UserCollectionViewCellConfigurator() }
    
    weak var delegate: HistoryCollectionDelegate!
    
    // MARK: - Initialisation
    
    deinit {
        print("Controller deallocated")
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        registerCell(cellType: RoundedImageCollectionViewCell.self)
        xCollectionView.cornerRadius = 10.0
        xCollectionView.cornerCurve = .continuous
        disableRefreshControl()
        disableBouncing(direction: .vertical)
    }
    
    // MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        let selectedKeyword = model.items[indexPath.row]
        delegate.add(model: selectedKeyword)
        updateView()
        delegate.didUpdateCollection()
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }*/
    
    /*override func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
            var delete: UIAction! = nil
            let model = self.model.items[indexPath.row]
            delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: [.destructive]) { action in
                self.delegate.delete(model: model)
                self.collectionView.deleteItems(at: [indexPath])
                self.delegate.didUpdateCollection()
            }
            return UIMenu(children: [delete])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }*/
    
}
