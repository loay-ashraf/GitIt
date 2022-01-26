//
//  TableViewDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewDelegate<Type>: NSObject, UITableViewDelegate {
    
    var model = List<Type>()
    weak var tableView: TableView!
    var tapResponder: TableViewTapResponder!
    var contextMenuConfigurator: TableViewContextMenuConfigurator!
    var scrollViewAction: (() -> Void)!
    
    override init() {
        super.init()
        self.tapResponder = TableViewTapResponder()
        self.contextMenuConfigurator = TableViewContextMenuConfigurator()
    }
    
    init(tapResponder: TableViewTapResponder, contextMenuConfigurator: TableViewContextMenuConfigurator?, scrollViewAction: (() -> Void)?) {
        super.init()
        self.tapResponder = tapResponder
        self.contextMenuConfigurator = contextMenuConfigurator
        self.scrollViewAction = scrollViewAction
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = model.items[indexPath.row]
        tapResponder.respondToTap(with: item)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = model.items[indexPath.row]
        return contextMenuConfigurator?.configure(with: item)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewAction?()
    }
    
}
