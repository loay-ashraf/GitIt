//
//  TableViewDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewDelegate<Type>: NSObject, UITableViewDelegate {
    
    var model: List<Type>!
    var detailViewControllerPresenter: TableViewDetailPresenter!
    var contextMenuConfigurator: TableViewContextMenuConfigurator!
    var scrollViewDidScrollAction: (() -> Void)!
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tableView = tableView as? SFDynamicTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            let modelItem = model.items[indexPath.row]
            detailViewControllerPresenter.pushViewController(with: modelItem)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = model.items[indexPath.row]
        return contextMenuConfigurator.configure(with: item)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollAction?()
    }
    
}
