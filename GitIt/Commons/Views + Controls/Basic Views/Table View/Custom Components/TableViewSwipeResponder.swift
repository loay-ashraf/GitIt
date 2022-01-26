//
//  TableViewSwipeResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class TableViewSwipeResponder {
    
    var customResponse: ((UITableView,UITableViewCell.EditingStyle,IndexPath,Any) -> Void)!
    
    init(customResponse: ((UITableView,UITableViewCell.EditingStyle,IndexPath,Any) -> Void)? = nil) {
        self.customResponse = customResponse
    }
    
    func respondToSwipe(tableView: UITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath, with item: Any) {
        customResponse(tableView,editingStyle,indexPath,item)
    }
    
}
