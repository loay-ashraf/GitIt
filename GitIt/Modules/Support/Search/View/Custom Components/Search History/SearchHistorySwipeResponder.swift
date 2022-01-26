//
//  SearchHistorySwipeResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/01/2022.
//

import UIKit

class SearchHistoryTableViewSwipeResponder: TableViewSwipeResponder {
    
    weak var historyTableDelegate: HistoryTableDelegate?
    
    init(delegate: HistoryTableDelegate) {
        self.historyTableDelegate = delegate
    }
    
    override func respondToSwipe(tableView: UITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath, with item: Any) {
        historyTableDelegate?.delete(keyWord: item as! String)
        tableView.deleteRows(at: [indexPath], with: .bottom)
        historyTableDelegate?.didUpdateTable()
    }
    
}
