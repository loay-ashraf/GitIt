//
//  TableViewCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

protocol TableViewCellConfigurator {
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type)
}
